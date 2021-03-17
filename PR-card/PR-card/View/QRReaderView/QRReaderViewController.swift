//
//  QRReaderViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import ARKit
import SceneKit
import Vision

class QRReaderViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var LoadingView: UIView!
    
    var drawLayer: CALayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        LoadingView.isHidden = true
        let image = UIImage(named:"License")!
        let image2 = UIImage(named:"License_Blue")!
        
        setImageToScene(image: image,x:-0.2)
        setImageToScene(image: image2,x:0.2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // 環境マッピングを有効にする
        configuration.environmentTexturing = .automatic
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //左横画面に変更
        if(UIDevice.current.orientation.rawValue == 4) {
            UIDevice.current.setValue(4, forKey: "orientation")
            return .landscapeLeft
        } else {
            //左横画面以外の処理
            //右横画面に変更させる。
            UIDevice.current.setValue(3, forKey: "orientation")
            return .landscapeRight
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let frame = self.sceneView.session.currentFrame {
            findQRCode(frame: frame)
        }
    }
    
    func setTextToScene(string: String){
        if let camera = sceneView.pointOfView {
            let depth:CGFloat = 0.2 // 奥行き0.2m
            //extrusionDepth: 文字の厚さ
            let text = SCNText(string: string, extrusionDepth: depth)
            text.font = UIFont.systemFont(ofSize: 1,weight: UIFont.Weight(rawValue: CGFloat(10)))// 文字の大きさを1に設定
            let billboardConstraint = SCNBillboardConstraint()
            billboardConstraint.freeAxes = SCNBillboardAxis.Y
            let textNode = SCNNode(geometry: text)
            // テキストを配置する場所を決める
            let (min, max) = (textNode.boundingBox)
            let textBoundsWidth = (max.x - min.x)
            let textBoundsHeight = (max.y - min.y)
            let position = camera.position
            textNode.position = SCNVector3(position.x-textBoundsWidth/2, position.y+0.2,position.z-1)
            textNode.pivot = SCNMatrix4MakeTranslation(textBoundsWidth/2 + min.x, textBoundsHeight/2 + min.y, 0)
            textNode.scale = SCNVector3(0.05,0.05,0.05)
            textNode.constraints = [billboardConstraint]
            self.sceneView.pointOfView?.addChildNode(textNode)
        }
    }
    
    private func createImageNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale / image.size.height, height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
    func setImageToScene(image: UIImage,x:Float) {
        if let camera = sceneView.pointOfView {
            let billboardConstraint = SCNBillboardConstraint()
            billboardConstraint.freeAxes = SCNBillboardAxis.Y
            let position = SCNVector3(x: x, y: 0, z: -0.5)
            let convertPosition = camera.convertPosition(position, to: nil)
            let imageNode = createImageNode(image, position: convertPosition)
            imageNode.constraints = [billboardConstraint]
            self.sceneView.scene.rootNode.addChildNode(imageNode)
        }
    }
    
    func findQRCode(frame currentFrame: ARFrame) {
        //Visionの解析処理をメインスレッドで行うとレスポンスが悪くなるのでバックグラウンドで行う
        DispatchQueue.global(qos: .background).async {
            // リクエストには処理が完了したときに呼ばれるハンドラを登録しておく
            let request = VNDetectBarcodesRequest(completionHandler: self.handleBarcodes)
            let handler = VNImageRequestHandler(cvPixelBuffer: currentFrame.capturedImage, orientation: .downMirrored, options: [:])
            do {
                try handler.perform([request])
            } catch let error as NSError {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
    
    func handleBarcodes(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let result = request.results?.first as? VNBarcodeObservation else {
                self.LoadingView.isHidden = true
                return
            }
            self.updateDrawLayer()
            if let drawLayer = self.drawLayer {
                self.draw(barcode: result, onImageLayer: drawLayer)
            }
            if let value = result.payloadStringValue {
                //MARK: QRコードから取得したURLを用いたサーバとの通信処理
                self.LoadingView.isHidden = false
                print(value)
            }
        }
    }
    
    func updateDrawLayer(){
        let layer = CALayer()
        if let drawLayer = self.drawLayer {
            drawLayer.sublayers?.forEach({ layer in
                layer.removeFromSuperlayer()
            })
        }
        layer.bounds = self.sceneView.bounds
        layer.anchorPoint = CGPoint.zero
        layer.opacity = 0.5
        self.view.layer.addSublayer(layer)
        self.drawLayer = layer
    }
    
    func draw(barcode: VNRectangleObservation, onImageLayer drawlayer: CALayer) {
        CATransaction.begin()
        let rectLayer = shapeLayerRect(color: .blue, observation: barcode)
        // Add to pathLayer on top of image.
        drawlayer.addSublayer(rectLayer)
        CATransaction.commit()
    }
    
    fileprivate func shapeLayerRect(color: UIColor, observation: VNRectangleObservation) -> CAShapeLayer {
        // Create a new layer.
        let layer = CAShapeLayer()
        guard let drawBounds = self.drawLayer?.bounds else { return layer }
        let orientation = UIApplication.shared.statusBarOrientation
        guard let arTransform = self.sceneView.session.currentFrame?.displayTransform(for: orientation, viewportSize: drawBounds.size) else { return layer }
        let affineTransform = CGAffineTransform(scaleX: drawBounds.width, y: drawBounds.height)
        let convertedTopLeft = observation.topLeft.applying(arTransform).applying(affineTransform)
        let convertedTopRight = observation.topRight.applying(arTransform).applying(affineTransform)
        let convertedBottomLeft = observation.bottomLeft.applying(arTransform).applying(affineTransform)
        let convertedBottomRight = observation.bottomRight.applying(arTransform).applying(affineTransform)
        
        let linePath = UIBezierPath()
        linePath.move(to: convertedTopLeft)
        linePath.addLine(to: convertedTopRight)
        linePath.addLine(to: convertedBottomRight)
        linePath.addLine(to: convertedBottomLeft)
        linePath.addLine(to: convertedTopLeft)
        linePath.close()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 5
        layer.path = linePath.cgPath
        
        return layer
    }
}

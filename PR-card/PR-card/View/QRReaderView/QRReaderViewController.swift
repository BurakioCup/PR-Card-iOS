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
        let scene = SCNScene()
        sceneView.scene = scene
        LoadingView.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView),
              let result = sceneView.hitTest(location, options: nil).first else {
            return
        }
        guard let camera = sceneView.pointOfView else {
            return
        }
        let node = result.node
        var x: Float = 0
        var y: Float = 0
        let z: Float = -3
        let targetPosCamera = SCNVector3Make(0, 0, -1)
        let zoomInPotision = camera.convertPosition(targetPosCamera, to: nil)
        if let touch = touches.first{
            if touch.tapCount == 1{
                let zoomInAction = SCNAction.move(to: zoomInPotision, duration: 0.8)
                node.runAction(zoomInAction)
            }
            if touch.tapCount == 2{
                switch node.name {
                    case "face":
                        x = -0.3
                        y = 0.2
                    case "name":
                        x = 0.3
                        y = 0.2
                    case "free":
                        x = 0.1
                        y = -0.5
                    case "status":
                        x = -0.4
                        y = -0.2
                    case "tag":
                        x = 0.4
                        y = -0.2
                    default:
                        break
                }
                let zoomOutPosition = SCNVector3Make(camera.position.x+x,camera.position.y+y,camera.position.z+z)
                let zoomOutAction = SCNAction.move(to: zoomOutPosition, duration: 0.8)
                node.runAction(zoomOutAction)
            }
        }
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
    
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale / image.size.height, height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        return node
    }
    
    func setImageToScene(image: UIImage,x:Float,y:Float,z:Float,scale:Float,name:String) {
        if let camera = sceneView.pointOfView {
            let billboardConstraint = SCNBillboardConstraint()
            billboardConstraint.freeAxes = SCNBillboardAxis.Y
            let position = camera.position
            let nodePosition = SCNVector3(x: position.x+x, y: position.y+y, z: position.z+z)
            let imageNode = createImageNode(image, position: nodePosition)
            imageNode.constraints = [billboardConstraint]
            imageNode.scale =  SCNVector3(scale,scale,scale)
            self.sceneView.scene.rootNode.addChildNode(imageNode)
            imageNode.name = name
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
            if let value = result.payloadStringValue {
            }
        }
    }
    
    }
}

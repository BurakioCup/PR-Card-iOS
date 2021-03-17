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
    
    let qrReaderPresenter = QRReaderPresenter()
    var drawLayer: CALayer?
    var isReadQRCord:Bool = false
    var isDrawUIImage:Bool = false
    var x: Float = 0
    var y: Float = 0
    var z: Float = -3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        LoadingView.isHidden = true
    }
    
    @IBAction func resetQRReaderButtonAction(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "PRカードリセット", message: "表示中のPRカードを消去しますか？", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.prCardDerete()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
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
        if isReadQRCord == false{
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
                if self.isDrawUIImage == false {
                    self.LoadingView.isHidden = false
                    self.getDataFromServer(value:value)
                    self.isReadQRCord = true
                    self.isDrawUIImage = true
                }
            }
        }
    }
    
    func getDataFromServer(value:String){
        DispatchQueue.global(qos: .background).async {
            self.qrReaderPresenter.application(cardID: value, completion: {[weak self] response in
                guard let self = self else { return }
                guard let faceImage_url = URL(string:response.faceImage ?? "") else { return }
                guard let nameImage_url = URL(string:response.nameImage ?? "") else { return }
                guard let freeImage_url = URL(string:response.freeImage ?? "") else { return }
                guard let statusImage_url = URL(string:response.statusImage ?? "") else { return }
                guard let tagImage_url = URL(string:response.tagImage ?? "") else { return }
                do {
                    let faceData = try Data(contentsOf: faceImage_url)
                    let nameData = try Data(contentsOf: nameImage_url)
                    let freeData = try Data(contentsOf: freeImage_url)
                    let statusData = try Data(contentsOf: statusImage_url)
                    let tagData = try Data(contentsOf: tagImage_url)
                    
                    let faceImage = UIImage(data: faceData)!
                    let nameImage = UIImage(data: nameData)!
                    let freeImage = UIImage(data: freeData)!
                    let statusImage = UIImage(data: statusData)!
                    let tagImage = UIImage(data: tagData)!
                    
                    self.LoadingView.isHidden = true
                    self.setImageToScene(image: faceImage, x: -0.5, y: 0.2, z: -3, scale: 1, name: "face")
                    self.setImageToScene(image: nameImage, x: -0.4, y: -0.2, z: -3, scale: 1, name: "name")
                    self.setImageToScene(image: freeImage, x: 0.1, y: -0.5, z: -3, scale: 0.7, name: "free")
                    self.setImageToScene(image: statusImage, x: 0.4, y: 0.2, z: -3, scale: 3, name: "status")
                    self.setImageToScene(image: tagImage, x: 0.4, y: -0.3, z: -3, scale: 1, name: "tag")
                    
                } catch {
                    print("error 01")
                }
            }
            )}
    }
}

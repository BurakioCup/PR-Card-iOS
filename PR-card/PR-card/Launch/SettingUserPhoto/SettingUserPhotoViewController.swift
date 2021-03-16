//
//  SettingUserPhotoViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/09.
//

import UIKit

class SettingUserPhotoViewController: UIViewController, UINavigationControllerDelegate {
    
    var timer: Timer = Timer()
    // 自動回転はOFFで縦に固定
    override var shouldAutorotate: Bool {
        //縦画面なので縦に固定
        UIDevice.current.setValue(1, forKey: "orientation")
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showUIAlert), userInfo: nil, repeats: false)
    }
    
    @objc func showUIAlert() {
        let alertController:UIAlertController =
            UIAlertController(title:"あなたの画像を登録してください",
                              message: "カメラかフォトライブラリから登録",
                              preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "カメラ", style: .default){ action in
            self.launchCamera()
        }
        
        let photoLibrary = UIAlertAction(title: "フォトライブラリ", style: .default){ action in
            self.launchPhotoLibrary()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){
            (action) -> Void in
        }
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func launchCamera() {
        // カメラが利用可能かどうかチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //imagePickerViewを表示する
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .camera
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController.init(title: nil, message: "このデバイスではカメラが使えません", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func launchPhotoLibrary() {
        // フォトライブラリが利用可能かどうかチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // フォトライブラリを起動
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController.init(title: nil, message: "フォトライブラリにアクセスできません", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension SettingUserPhotoViewController: UIImagePickerControllerDelegate {
    
    // pickerの選択がキャンセルされた時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // 画像が選択(撮影)された時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("The image was selected")
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? else { return
        }
        
        dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "UserInfoPreview", bundle: nil)
        let userInfoPreviewVC = storyboard.instantiateViewController(identifier: "UserInfoPreview") as UserInfoPreviewViewController
        userInfoPreviewVC.photo = selectedImage
        navigationController?.pushViewController(userInfoPreviewVC, animated: true)
    }
}

//
//  SettingUserNameViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/08.
//

import UIKit

class SettingUserNameViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    let userDefaults = UserDefaults.standard
    let userNameKey = "userName"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func finish(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SettingUserPhoto", bundle: nil)
        let settingUserPhotoVC = storyboard.instantiateViewController(identifier: "SettingUserPhoto") as SettingUserPhotoViewController
        navigationController?.pushViewController(settingUserPhotoVC, animated: true)
    }
    
    // キーボード出現時にViewを上にあげる
    @objc func keyboardWillShow(notification: NSNotification) {
        // 編集中のtextFieldを取得
        guard let userNameTextField = userNameTextField else { return }
        
        if userNameTextField.isFirstResponder {
            if view.frame.origin.y == 0 {
                if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    view.frame.origin.y -= keyboardRect.height
                }
            }
        }
    }
    
    // キーボードが閉じられた時にViewの高さを元に戻す
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

extension SettingUserNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("ユーザネーム: \(textField.text ?? "none")")
        userDefaults.setValue(textField.text, forKey: userNameKey)
        userDefaults.synchronize()
    }
}

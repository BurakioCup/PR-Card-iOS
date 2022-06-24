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
    let userNamekey = "userName"
    
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
        guard let textField = userNameTextField else { return }
        // キーボード、画面全体、textFieldのsizeを取得
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let textFieldHeight = textField.frame.height
        
        // ① テキストフィールドの底辺より10.0下のy座標を取得
        let textFieldPositionY = textField.frame.origin.y + textFieldHeight + 10.0
        
        // ② キーボードの底辺のy座標を取得
        let keyboardPositionY = mainBoundsSize.height - keyboardHeight
        
        // ③キーボードをずらす
        if keyboardPositionY <= textFieldPositionY {
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - textFieldPositionY)
            }
        }
    }
    
    // キーボードが閉じられた時にViewの高さを元に戻す
    @objc func keyboardWillHide(notification: NSNotification) {
        let duration: TimeInterval? = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
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
        userDefaults.setValue(textField.text, forKey: userNamekey)
        userDefaults.synchronize()
    }
}

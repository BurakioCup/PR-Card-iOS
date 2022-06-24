//
//  CreateAccountViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var signupPresenter = SignupPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8781483173, green: 0.8781483173, blue: 0.8781483173, alpha: 1) // ナビゲーションバーの背景色
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor(hex: "9a9a9a", alpha: 1.0)
            ]
        idTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        signupPresenter.signup()
        let storyboard = UIStoryboard(name: "SettingUserName", bundle: nil)
        let settingUserNameVC = storyboard.instantiateViewController(identifier: "SettingUserName") as SettingUserNameViewController
        navigationController?.pushViewController(settingUserNameVC, animated: true)
    }
    
    // キーボード出現時にViewを上にあげる
    @objc func keyboardWillShow(notification: NSNotification) {
        // 編集中のtextFieldを取得
        guard let idTextField = idTextField else { return }
        guard let passwordTextField = passwordTextField else { return }
        
        // キーボード、画面全体、textFieldのsizeを取得
        let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = rect?.size.height else { return }
        let mainBoundsSize = UIScreen.main.bounds.size
        let idTextFieldHeight = idTextField.frame.height
        let passwordTextFieldHeight = passwordTextField.frame.height
        
        // ① テキストフィールドの底辺より10.0下のy座標を取得
        let idFieldPositionY = idTextField.frame.origin.y + idTextFieldHeight + 10.0
        let passwordFieldPositionY = passwordTextField.frame.origin.y + passwordTextFieldHeight + 10.0
        
        // ② キーボードの底辺のy座標を取得
        let keyboardPositionY = mainBoundsSize.height - keyboardHeight
        
        // ③キーボードをずらす
        if idTextField.isFirstResponder {
            print("firstTextField.isFirstResponder")
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - idFieldPositionY)
            }
        } else if passwordTextField.isFirstResponder {
            print("secondTextField.isFirstResponder")
            let duration: TimeInterval? =
            notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!) {
                // viewをy座標方向にtransformする
                self.view.transform = CGAffineTransform(translationX: 0, y: keyboardPositionY - passwordFieldPositionY)
            }
        }
    }
    
    // キーボードが閉じられた時にViewの高さを元に戻す
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
        UIView.animate(withDuration: TimeInterval(duration), animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        idTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let userDefaults = UserDefaults.standard
        let signKey = "signup"
        let signupInfo = [idTextField.text, passwordTextField.text]
        print("idとpass\(signupInfo)")
        userDefaults.setValue(signupInfo, forKey: signKey)
        userDefaults.synchronize()
        
    }
}

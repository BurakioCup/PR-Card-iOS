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
        
        if idTextField.isFirstResponder {
            if view.frame.origin.y == 0 {
                if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    view.frame.origin.y -= keyboardRect.height
                }
            }
        }
        
        if passwordTextField.isFirstResponder {
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

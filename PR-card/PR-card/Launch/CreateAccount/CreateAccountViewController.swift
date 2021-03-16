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
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        signupPresenter.signup()
        let storyboard = UIStoryboard(name: "SettingUserName", bundle: nil)
        let settingUserNameVC = storyboard.instantiateViewController(identifier: "SettingUserName") as SettingUserNameViewController
        navigationController?.pushViewController(settingUserNameVC, animated: true)
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

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
    }
    
    @IBAction func finish(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SettingUserPhoto", bundle: nil)
        let settingUserPhotoVC = storyboard.instantiateViewController(identifier: "SettingUserPhoto") as SettingUserPhotoViewController
        navigationController?.pushViewController(settingUserPhotoVC, animated: true)
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

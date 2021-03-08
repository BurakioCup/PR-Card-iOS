//
//  CreateAccountViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8781483173, green: 0.8781483173, blue: 0.8781483173, alpha: 1) // ナビゲーションバーの背景色
        self.navigationController?.navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor(hex: "9a9a9a", alpha: 1.0)
            ]
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SettingUserName", bundle: nil)
        let settingUserNameVC = storyboard.instantiateViewController(identifier: "SettingUserName") as SettingUserNameViewController
        navigationController?.pushViewController(settingUserNameVC, animated: true)
    }
}

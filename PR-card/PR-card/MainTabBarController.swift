//
//  MainTabBarController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1 // デフォルト画面を設定
        
        let userDefaults = UserDefaults.standard
        let firstLunchKey = "firstLunchKey"
        if userDefaults.bool(forKey: firstLunchKey) {
            print("２回目以降の起動")
            let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBar") as MainTabBarController
            mainTabBarController.modalPresentationStyle = .fullScreen
            present(mainTabBarController, animated: true, completion: nil)
        } else {
            print("初回起動")
            let storyboard = UIStoryboard(name: "CreateAccount", bundle: nil)
            let createAccountVC = storyboard.instantiateViewController(identifier: "CreateAccount") as CreateAccountViewController
            createAccountVC.modalPresentationStyle = .fullScreen
            present(createAccountVC, animated: true, completion: nil)
        }
    }
    
}

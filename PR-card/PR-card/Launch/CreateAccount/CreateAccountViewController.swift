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
        
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let mainTabBarVC = storyboard.instantiateViewController(identifier: "MainTabBar") as MainTabBarController
        mainTabBarVC.modalPresentationStyle = .fullScreen
        self.present(mainTabBarVC, animated: true, completion: nil)
//        cardsVC.modalPresentationStyle = .fullScreen
//        self.present(cardsVC, animated: true, completion: nil)
    }
}

//
//  TagsEditPreviewViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/10.
//

import UIKit

class TagsEditPreviewViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstHashTagLabel: UILabel!
    @IBOutlet weak var secondHashTagLabel: UILabel!
    @IBOutlet weak var ThirdHashTagLabel: UILabel!
    @IBOutlet weak var fourthHashTagLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    let userDefaults = UserDefaults.standard
    let userNamekey = "userName"
    let nickNameKey = "nickName"
    let first = "first"
    let second = "second"
    let third = "third"
    let fourth = "fourth"
    let fifth = "fifth"
    let freeComment = "freeComment"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        userNameLabel.text = userDefaults.string(forKey: userNamekey)
        nickNameLabel.text = userDefaults.string(forKey: nickNameKey)
        firstHashTagLabel.text = userDefaults.string(forKey: first)
        secondHashTagLabel.text = userDefaults.string(forKey: second)
        ThirdHashTagLabel.text = userDefaults.string(forKey: third)
        fourthHashTagLabel.text = userDefaults.string(forKey: fourth)
        commentContentLabel.text = userDefaults.string(forKey: freeComment)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        //左横画面に変更
        if(UIDevice.current.orientation.rawValue == 4) {
            UIDevice.current.setValue(4, forKey: "orientation")
            return .landscapeLeft
        } else {
            //左横画面以外の処理
            //右横画面に変更させる。
            UIDevice.current.setValue(3, forKey: "orientation")
            return .landscapeRight
        }
    }
    
    @IBAction func tagsReconfiguration(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TagsEdit", bundle: nil)
        let tagsEditVC = storyboard.instantiateViewController(identifier: "TagsEdit") as TagsEditViewController
        navigationController?.pushViewController(tagsEditVC, animated: true)
    }
    
    @IBAction func tagsFinish(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainTabBar", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBar") as MainTabBarController
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: nil)
    }
    
    
}

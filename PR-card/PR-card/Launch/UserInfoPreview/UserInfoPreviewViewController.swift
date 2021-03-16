//
//  UserInfoPreviewViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/09.
//

import UIKit

class UserInfoPreviewViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        userPhoto.image = photo
    }
    
    // 再設定ボタン
    @IBAction func reconfigurationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SettingUserName", bundle: nil)
        let settingUserNameVC = storyboard.instantiateViewController(identifier: "SettingUserName") as SettingUserNameViewController
        navigationController?.pushViewController(settingUserNameVC, animated: true)
    }
    
    // 完了ボタン
    @IBAction func finishButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ScreenRotation", bundle: nil)
        let screenRotationVC = storyboard.instantiateViewController(identifier: "ScreenRotation") as ScreenRotationViewController
        navigationController?.pushViewController(screenRotationVC, animated: true)
    }
}

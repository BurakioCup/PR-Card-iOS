//
//  SettingUserNameViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/08.
//

import UIKit

class SettingUserNameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func nameVoiceButton(_ sender: Any) {
        print("voice")
        let storyboard = UIStoryboard(name: "SettingUserPhoto", bundle: nil)
        let settingUserPhotoVC = storyboard.instantiateViewController(identifier: "SettingUserPhoto") as SettingUserPhotoViewController
        navigationController?.pushViewController(settingUserPhotoVC, animated: true)
    }
}

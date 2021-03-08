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
        let storyboard = UIStoryboard(name: "ScreenRotation", bundle: nil)
        let screenRotationVC = storyboard.instantiateViewController(identifier: "ScreenRotation") as ScreenRotationViewController
        navigationController?.pushViewController(screenRotationVC, animated: true)
    }
}

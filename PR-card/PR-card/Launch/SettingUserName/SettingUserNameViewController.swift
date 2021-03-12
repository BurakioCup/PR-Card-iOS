//
//  SettingUserNameViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/08.
//

import UIKit

class SettingUserNameViewController: UIViewController {

    @IBOutlet weak var nameVoiceButtonImage: UIButton!
    var isButtonPushed = false // 初期状態押されていない
    var buttonImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonImage = UIImage(named: "Microphone")
        nameVoiceButtonImage.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func nameVoiceButton(_ sender: Any) {
        if isButtonPushed {
            buttonImage = UIImage(named: "Microphone")
            nameVoiceButtonImage.setImage(buttonImage, for: .normal)
            isButtonPushed = false
        } else {
            buttonImage = UIImage(named: "Microphone_push")
            nameVoiceButtonImage.setImage(buttonImage, for: .normal)
            isButtonPushed = true
        }
        print("voice")
//        let storyboard = UIStoryboard(name: "SettingUserPhoto", bundle: nil)
//        let settingUserPhotoVC = storyboard.instantiateViewController(identifier: "SettingUserPhoto") as SettingUserPhotoViewController
//        navigationController?.pushViewController(settingUserPhotoVC, animated: true)
    }
}

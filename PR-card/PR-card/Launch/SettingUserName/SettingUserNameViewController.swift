//
//  SettingUserNameViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/08.
//

import UIKit
import Speech
import AVFoundation

class SettingUserNameViewController: UIViewController {

    @IBOutlet weak var nameVoiceButtonImage: UIButton!
    var isButtonPushed = false // 初期状態押されていない
    var buttonImage: UIImage!
    var recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ja_JP"))!
    var audioEngine: AVAudioEngine!
    var recognitionReq: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SFSpeechRecognizer.requestAuthorization({ authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("許可された")
                
                case .denied:
                    print("拒否された")
                
                case .restricted: break
                    
                case .notDetermined: break
                }
            }
        })
        
        buttonImage = UIImage(named: "Microphone")
        nameVoiceButtonImage.setImage(buttonImage, for: .normal)
        audioEngine = AVAudioEngine()
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
    
    func startLiveTranscription() throws {
    }
}

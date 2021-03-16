//
//  TagsEditViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/10.
//

import AVFoundation
import Speech
import UIKit

class TagsEditViewController: UIViewController {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstHashTagLabel: UILabel!
    @IBOutlet weak var secondHashTagLabel: UILabel!
    @IBOutlet weak var ThirdHashTagLabel: UILabel!
    @IBOutlet weak var fourthHashTagLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var voiceButton: UIButton!
    let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ja_JP"))!
    var audioEngine: AVAudioEngine!
    var recognitionReq: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var isTapped = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        audioEngine = AVAudioEngine()
        voiceButton.setImage(UIImage(named: "Microphone"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized: // 許可された
                        print("音声認識許可")
                    case .denied: // 拒否された
                        print("音声認識拒否")

                    case .restricted:
                        print("この端末で音声認識不可")
                        
                    case .notDetermined:
                        print("認可状況未確定")
                @unknown default:
                    fatalError()
                }
            }
        }
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
    
    @IBAction func voiceInputButton(_ sender: Any) {
        if isTapped {
            voiceButton.setImage(UIImage(named: "Microphone"), for: .normal)
            isTapped = false
            stopLiveTranscription()
        } else {
            voiceButton.setImage(UIImage(named: "Microphone_push"), for: .normal)
            isTapped = true
            do {
                try startLiveTranscription()
            } catch  {
                print("音声認識できませんでした")
            }
        }
    }
    
    // 音声認識中止
    func stopLiveTranscription() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionReq?.endAudio()
    }
    
    // 音声認識開始
    func startLiveTranscription() throws {
        
        // もし前回の音声認識タスクが実行中ならキャンセル
        if let recognitionTask = self.recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // 音声認識リクエストの作成
        recognitionReq = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionReq = recognitionReq else {
            return
        }
        
        // オーディオセッションの設定
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // マイク入力の設定
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer, time) in
            recognitionReq.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = recognizer.recognitionTask(with: recognitionReq, resultHandler: { (result, error) in
            if let error = error {
                print("\(error)")
            } else {
                DispatchQueue.main.async {
                    print(result?.bestTranscription.formattedString)
                }
            }
        })
    }
}

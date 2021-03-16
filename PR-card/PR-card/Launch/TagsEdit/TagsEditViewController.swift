//
//  TagsEditViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/10.
//

import AVFoundation
import Instructions
import Speech
import UIKit

class TagsEditViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
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
    var coachController = CoachMarksController()
    private var views: [UIView] = []
    private let messages = ["あなたのあだ名を入力", "あなたを表す単語", "あなたを表す単語", "あなたを表す単語", "あなたを表す単語", "好きなコメントを入力"]
    var voiceRecognition: String?
    let userDefaults = UserDefaults.standard
    let userNamekey = "userName"
    let nickNameKey = "nickName"
    let first = "first"
    let second = "second"
    let third = "third"
    let fourth = "fourth"
    let fifth = "fifth"
    let freeComment = "freeComment"
    let tagsEditPresenter = TagsEditPresenter()
    // 非同期のグループ
    let dispatchGroup = DispatchGroup()
    // 並列で実行
    let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
        audioEngine = AVAudioEngine()
        voiceButton.setImage(UIImage(named: "Microphone"), for: .normal)
        coachController.dataSource = self
        views = [nickNameLabel, firstHashTagLabel, secondHashTagLabel, ThirdHashTagLabel, fourthHashTagLabel, commentContentLabel]
        voiceButton.isEnabled = false
        userNameLabel.text = userDefaults.string(forKey: userNamekey)
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
        self.coachController.start(in: .window(over: self))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachController.stop(immediately: true)
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
    
    @IBAction func nickNameLabelTap(_ sender: Any) {
        print(nickNameLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        firstHashTagLabel.layer.borderWidth = 0.0
        secondHashTagLabel.layer.borderWidth = 0.0
        ThirdHashTagLabel.layer.borderWidth = 0.0
        fourthHashTagLabel.layer.borderWidth = 0.0
        commentContentLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        nickNameLabel.layer.borderWidth = 1.0
        nickNameLabel.layer.borderColor = UIColor.black.cgColor
        nickNameLabel.layer.cornerRadius = 10.0
        nickNameLabel.clipsToBounds = true
        
        guard let str = voiceRecognition else { return }
        nickNameLabel.text = str
    }
    
    @IBAction func firstHashTagTap(_ sender: Any) {
        print(firstHashTagLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        nickNameLabel.layer.borderWidth = 0.0
        secondHashTagLabel.layer.borderWidth = 0.0
        ThirdHashTagLabel.layer.borderWidth = 0.0
        fourthHashTagLabel.layer.borderWidth = 0.0
        commentContentLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        firstHashTagLabel.layer.borderWidth = 1.0
        firstHashTagLabel.layer.borderColor = UIColor.black.cgColor
        firstHashTagLabel.layer.cornerRadius = 10.0
        firstHashTagLabel.clipsToBounds = true
        
        guard let str = voiceRecognition else { return }
        firstHashTagLabel.text = str
    }
    
    @IBAction func secondHashTagTap(_ sender: Any) {
        print(secondHashTagLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        nickNameLabel.layer.borderWidth = 0.0
        firstHashTagLabel.layer.borderWidth = 0.0
        ThirdHashTagLabel.layer.borderWidth = 0.0
        fourthHashTagLabel.layer.borderWidth = 0.0
        commentContentLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        secondHashTagLabel.layer.borderWidth = 1.0
        secondHashTagLabel.layer.borderColor = UIColor.black.cgColor
        secondHashTagLabel.layer.cornerRadius = 10.0
        secondHashTagLabel.clipsToBounds = true
        
        guard let str = voiceRecognition else { return }
        secondHashTagLabel.text = str
    }
    
    @IBAction func thirdHashTagTap(_ sender: Any) {
        print(ThirdHashTagLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        nickNameLabel.layer.borderWidth = 0.0
        firstHashTagLabel.layer.borderWidth = 0.0
        secondHashTagLabel.layer.borderWidth = 0.0
        fourthHashTagLabel.layer.borderWidth = 0.0
        commentContentLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        ThirdHashTagLabel.layer.borderWidth = 1.0
        ThirdHashTagLabel.layer.borderColor = UIColor.black.cgColor
        ThirdHashTagLabel.layer.cornerRadius = 10.0
        ThirdHashTagLabel.clipsToBounds = true
        
        guard let str = voiceRecognition else { return }
        ThirdHashTagLabel.text = str
    }
    @IBAction func fourthHashTagTap(_ sender: Any) {
        print(fourthHashTagLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        nickNameLabel.layer.borderWidth = 0.0
        firstHashTagLabel.layer.borderWidth = 0.0
        secondHashTagLabel.layer.borderWidth = 0.0
        ThirdHashTagLabel.layer.borderWidth = 0.0
        commentContentLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        fourthHashTagLabel.layer.borderWidth = 1.0
        fourthHashTagLabel.layer.borderColor = UIColor.black.cgColor
        fourthHashTagLabel.layer.cornerRadius = 10.0
        fourthHashTagLabel.clipsToBounds = true
        
        guard let str = voiceRecognition else { return }
        fourthHashTagLabel.text = str
    }
    @IBAction func commentTap(_ sender: Any) {
        print(commentContentLabel.text as Any)
        voiceButton.isEnabled = true
        
        // 他のUILabelの枠線を消す
        nickNameLabel.layer.borderWidth = 0.0
        firstHashTagLabel.layer.borderWidth = 0.0
        secondHashTagLabel.layer.borderWidth = 0.0
        ThirdHashTagLabel.layer.borderWidth = 0.0
        fourthHashTagLabel.layer.borderWidth = 0.0
        
        // 自身のUIlabelの枠線つける
        commentContentLabel.layer.borderWidth = 1.0
        commentContentLabel.layer.borderColor = UIColor.black.cgColor
        commentContentLabel.layer.cornerRadius = 10.0
        commentContentLabel.clipsToBounds = true
        guard let str = voiceRecognition else { return }
        commentContentLabel.text = str
    }
    
    @IBAction func voiceInputButton(_ sender: Any) {
        voiceRecognition = nil
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
    
    @IBAction func toTagsEditPreview(_ sender: Any) {
        dispatchGroup.enter()
        dispatchQueue.async {
            self.tagsEditPresenter.cardDetails(name: self.userNameLabel.text ?? "", nickName: self.nickNameLabel.text ?? "", hashTags: [self.firstHashTagLabel.text ?? "", self.secondHashTagLabel.text ?? "", self.ThirdHashTagLabel.text ?? "", self.fourthHashTagLabel.text ?? ""], freeText: self.commentContentLabel.text ?? "", completion: {
                cardDetailsModel in
                self.dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.userDefaults.setValue(self.nickNameLabel.text, forKey: self.nickNameKey)
            self.userDefaults.setValue(self.firstHashTagLabel.text, forKey: self.first)
            self.userDefaults.setValue(self.secondHashTagLabel.text, forKey: self.second)
            self.userDefaults.setValue(self.ThirdHashTagLabel.text, forKey: self.third)
            self.userDefaults.setValue(self.fourthHashTagLabel.text, forKey: self.fourth)
            self.userDefaults.setValue(self.commentContentLabel.text, forKey: self.freeComment)
            self.userDefaults.synchronize()
            
            let storyboard = UIStoryboard(name: "TagsEditPreview", bundle: nil)
            let tagsEditPreviewVC = storyboard.instantiateViewController(identifier: "TagsEditPreview") as TagsEditPreviewViewController
            self.navigationController?.pushViewController(tagsEditPreviewVC, animated: true)
        }
    }
    
    // 音声認識中止
    func stopLiveTranscription() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionReq?.endAudio()
        voiceRecognition = nil
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
                    print("音声認識結果\(result?.bestTranscription.formattedString)")
                    self.voiceRecognition = result?.bestTranscription.formattedString
                }
            }
        })
    }
}

extension TagsEditViewController: CoachMarksControllerDataSource {
    
    // コーチマークの個数
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return views.count
    }
    
    // コーチマークの配置と表示方法をカスタマイズ
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachController.helper.makeCoachMark(for: views[index], pointOfInterest: nil, cutoutPathMaker: nil)
    }
    
    // コーチマークに表示する文章を設定
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = messages[index] // ここで文章を設定
        coachViews.bodyView.nextLabel.text = "了解"
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

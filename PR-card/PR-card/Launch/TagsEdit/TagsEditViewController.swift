//
//  TagsEditViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/10.
//

import UIKit

class TagsEditViewController: UIViewController {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstHashTagLabel: UILabel!
    @IBOutlet weak var secondHashTagLabel: UILabel!
    @IBOutlet weak var ThirdHashTagLabel: UILabel!
    @IBOutlet weak var fourthHashTagLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
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
    }
    
}
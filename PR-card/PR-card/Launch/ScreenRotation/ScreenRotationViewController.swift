//
//  ScreenRotationViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/08.
//

import UIKit

class ScreenRotationViewController: UIViewController {

    var timer: Timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeView), userInfo: nil, repeats: false)
    }
    
    @objc func changeView() {
        print("３秒経過したので画面遷移")
    }
    
}

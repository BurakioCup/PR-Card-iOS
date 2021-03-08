//
//  SettingUserPhotoViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/09.
//

import UIKit

class SettingUserPhotoViewController: UIViewController {
    
    // 自動回転はOFFで縦に固定
    override var shouldAutorotate: Bool {
        //縦画面なので縦に固定
        UIDevice.current.setValue(1, forKey: "orientation")
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

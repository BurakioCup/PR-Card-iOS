//
//  ParametersItemIntroductionViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/15.
//

import UIKit

class ParametersItemIntroductionViewController: UIViewController {

    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面向きを左横画面でセットする
        UIDevice.current.setValue(4, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(toParameterItemSetting), userInfo: nil, repeats: false)
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
    
    @objc func toParameterItemSetting() {
        let storyboard = UIStoryboard(name: "ParametersItemSetting", bundle: nil)
        let parametersItemSettingVC = storyboard.instantiateViewController(identifier: "ParametersItemSetting") as ParametersItemSettingViewController
        navigationController?.pushViewController(parametersItemSettingVC, animated: true)
    }
}

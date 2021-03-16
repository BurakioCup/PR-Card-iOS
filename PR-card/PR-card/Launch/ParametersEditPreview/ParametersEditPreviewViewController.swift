//
//  ParametersEditPreviewViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/09.
//

import UIKit

class ParametersEditPreviewViewController: UIViewController {

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
    
    // レーダーチャート再設定
    @IBAction func reconfigurationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ParametersEdit", bundle: nil)
        let parametersEditVC = storyboard.instantiateViewController(identifier: "ParametersEdit") as ParametersEditViewController
        navigationController?.pushViewController(parametersEditVC, animated: true)
    }
    
    // レーダーチャート編集完了
    @IBAction func finishButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TagsEdit", bundle: nil)
        let tagsEditVC = storyboard.instantiateViewController(identifier: "TagsEdit") as TagsEditViewController
        navigationController?.pushViewController(tagsEditVC, animated: true)
    }
    
}

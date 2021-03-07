//
//  CardsViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

class CardsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //画面向きを縦画面でセットする
        UIDevice.current.setValue(1, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        //縦画面なので縦に固定
        UIDevice.current.setValue(1, forKey: "orientation")
        return false
    }
}

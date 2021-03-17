//
//  MyProfileViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

let myProfilePresenter = MyProfilePresenter()

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var FaceImage: UIImageView!
    @IBOutlet weak var NameImage: UIImageView!
    @IBOutlet weak var FreeImage: UIImageView!
    @IBOutlet weak var TagImage: UIImageView!
    @IBOutlet weak var StatusImage: UIImageView!
    
    @IBAction func ReturnEdit(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ParametersEdit", bundle: nil)
        let parametersEditVC = storyboard.instantiateViewController(identifier: "ParametersEdit") as ParametersEditViewController
        parametersEditVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(parametersEditVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfilePresenter.application(completion: { [weak self] response in
            
            guard let self = self else { return }
            
            
            guard let faceimage = response.faceImage else { return }
            let url1 = URL(string: (faceimage))!
            
            do {
                let data = try Data(contentsOf: url1)
                self.FaceImage.image = UIImage(data: data)
            } catch let err {
                //画像がない場合デフォルトURLセット
                self.FaceImage.image = UIImage(named: "sample")
            }
            
            
            guard let nameimage = response.nameImage else { return }
            let url2 = URL(string: (nameimage))!
            
            do {
                let data = try Data(contentsOf: url2)
                self.NameImage.image = UIImage(data: data)
            } catch let err {
                //画像がない場合デフォルトURLセット
                self.NameImage.image = UIImage(named: "sample")
            }
            
            
            guard let statusImage = response.statusImage else { return }
            let url3 = URL(string: (statusImage))!
            
            do {
                let data = try Data(contentsOf: url3)
                self.StatusImage.image = UIImage(data: data)
            } catch let err {
                //画像がない場合デフォルトURLセット
                self.StatusImage.image = UIImage(named: "sample")
            }
            
            
            guard let tagimage = response.tagImage else { return }
            let url4 = URL(string: (tagimage))!
            
            do {
                let data = try Data(contentsOf: url4)
                self.TagImage.image = UIImage(data: data)
            } catch let err {
                //画像がない場合デフォルトURLセット
                self.TagImage.image = UIImage(named: "sample")
            }
            
            
            guard let freeimage = response.freeImage else { return }
            let url5 = URL(string: (freeimage))!
            
            do {
                let data = try Data(contentsOf: url5)
                self.FreeImage.image = UIImage(data: data)
            } catch let err {
                //画像がない場合デフォルトURLセット
                self.FreeImage.image = UIImage(named: "sample")
            }
            
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
}

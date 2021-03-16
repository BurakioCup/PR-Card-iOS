//
//  MyQRViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import Foundation
import UIKit

let myQRpresenter = MyQRPresenter()

class MyQRViewController: UIViewController {
@IBOutlet weak var QRimageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myQRpresenter.application(completion: { [weak self] response in
            
            guard let self = self else { return }
            let MyQRImage = response.qrImage
            
            guard let encodedImageData = MyQRImage else { return }
            let imageData = NSData(base64Encoded: encodedImageData)
            let image = UIImage(data: imageData as! Data)
            
            
            self.QRimageView.image = image
            
            
        })
        
    }
}

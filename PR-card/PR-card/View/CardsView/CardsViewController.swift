//
//  CardsViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit

var cell = UICollectionView()

class CardsViewController: UIViewController,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func MyPRcard(_ sender: Any) {
        let vc = UIStoryboard(name: "MyQR", bundle: nil).instantiateViewController(withIdentifier:"Next") as! MyQRViewController
        present(vc, animated: true, completion: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CardsViewCell", bundle: nil), forCellWithReuseIdentifier: "CardsViewCell")
        
        // xib関係の処理
        collectionView.delegate = self
        collectionView.dataSource = self
                
        // cellのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumInteritemSpacing = 0
        
        collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        
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
    
    extension CardsViewController: UICollectionViewDataSource{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
        }
            
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsViewCell", for: indexPath) as! CardsViewCell
            return cell
        }
    }

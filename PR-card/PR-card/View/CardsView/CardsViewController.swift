//
//  CardsViewController.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import Foundation
import UIKit

var cell = UICollectionView()

let cardspresenter = CardsPresenter()

class CardsViewController: UIViewController,UIGestureRecognizerDelegate{

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
            return 5
        }
            
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardsViewCell", for: indexPath) as! CardsViewCell
            
            //非同期処理
            cardspresenter.application(completion: { [weak self] response in
                
                guard let self = self else { return }
                let Cardscell = response.cards
                
                guard var cardID = Cardscell[indexPath.row].cardID else { return }
                guard var userName = Cardscell[indexPath.row].userName else { return }
                guard var faceImage = Cardscell[indexPath.row].faceImage else { return }
                
                cell.userNameLabel.text = userName
    
                let url = URL(string: (userName))!
        
                do {
                    let data = try Data(contentsOf: url)
                    cell.userIconImage.image = UIImage(data: data)
                } catch let err {
                    //画像がない場合デフォルトURLセット
                    cell.userIconImage.image = UIImage(named: "sample")
                }
            
                
                
            })
            
            return cell
        }
    }

    extension CardsViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            //var UserID = IDnumbers[indexPath.row]
            //UserDefaults.standard.set(UserID, forKey: "userID")
            
            let vc2 = UIStoryboard(name: "OtherDetailCards", bundle: nil).instantiateViewController(withIdentifier:"OtherdetailcardsViewController") as! OtherDetailCardsViewController
            vc2.modalPresentationStyle = .fullScreen
            
            navigationController?.pushViewController(vc2, animated: true)
        
        }
    }

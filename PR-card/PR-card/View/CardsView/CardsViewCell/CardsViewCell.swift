//
//  CardsViewCell.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/07.
//

import UIKit
import Foundation

protocol CardsViewDelegate {
    func addButtonTaped(_ sender: UIButton)
}

class CardsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userIconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var cardsViewDelegate: CardsViewDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}

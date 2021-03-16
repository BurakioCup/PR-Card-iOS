//
//  LoadingView.swift
//  PR-card
//
//  Created by keita on 2021/03/15.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            loadNib()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.loadNib()
        }
        
        fileprivate func loadNib() {
            guard let view = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
                return
            }
            loadingIcon.startAnimating()
                self.addSubview(view)
        }

}

//
//  MyQR.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/17.
//

import Foundation

struct QR: Codable{
    
    let qrImage: String?
     
    enum Codingkeys: String{
        case qrImage
    }
}

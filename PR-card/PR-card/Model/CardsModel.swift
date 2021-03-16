//
//  CardsModel.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/16.
//

import Foundation

struct Readall: Codable{
    let cards: [Cards]
}

struct Cards: Codable{
    
    let cardID: String?
    let userName: String?
    let faceImage: String?
    
    enum Codingkeys: String{
        case cardID
        case userName
        case aceImage
    }
}

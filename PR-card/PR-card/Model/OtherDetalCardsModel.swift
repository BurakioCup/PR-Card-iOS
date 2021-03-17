//
//  OtherDetalCarsModel.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/17.
//

import Foundation

struct OtherCards: Codable{
    
    let nameImage: String?
    let faceImage: String?
    let tagImage: String?
    let statusImage: String?
    let freeImage: String?
     
    enum Codingkeys: String{
        case nameImage
        case faceImage
        case tagImage
        case statusImage
        case freeImage
    }
}

//
//  TagsEditPresenter.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/17.
//

import Alamofire
import Foundation

class TagsEditPresenter {
    func cardDetails(name: String, nickName: String, hashTags: [String], freeText: String, completion: @escaping (CardDetailsModel) -> Void) {
        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/create/card/details") else {
            return
        }
        print(requestURL)
        
        let userDefaults = UserDefaults.standard
        let tokenKey = "usertoken"
        let parameters: [String : Any] =  [
            "name": name,
            "nickName": nickName,
            "hashTags": hashTags,
            "freeText": freeText
        ]
        
        let header: HTTPHeaders = ["token": "\(userDefaults.string(forKey: tokenKey) ?? "")"]
        
        AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            let decoder = JSONDecoder()
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                guard let cardDetailsModel = try? decoder.decode(CardDetailsModel.self, from: data) else { return }
                guard let nameImageUrl = URL(string: (cardDetailsModel.nameImage!)) else { return }
                guard let tagImageUrl = URL(string: (cardDetailsModel.tagImage!)) else { return }
                guard let freeImageUrl = URL(string: (cardDetailsModel.freeImage!)) else { return }
                completion(cardDetailsModel)
            case .failure(_):
                print(response.error as Any)
            }
        }
    }
}

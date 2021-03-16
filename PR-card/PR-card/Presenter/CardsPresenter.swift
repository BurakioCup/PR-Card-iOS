//
//  CardsModel.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/16.
//

import Foundation
import Alamofire
import SwiftyJSON

class CardsPresenter{
    
    var userDefaults = UserDefaults.standard
    
    func application(completion: @escaping (Readall) -> Void) {
    
        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/read/all") else {
            return
        }
        print(requestURL)
        
        UserDefaults.standard.set("taketo", forKey: "usertoken")
        var token = UserDefaults.standard.string(forKey: "usertoken")
        
        let parameters: HTTPHeaders = [
                    "token": "\(token ?? "")"
                ]
        
        AF.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: parameters ).responseJSON { response in
            
            let decoder = JSONDecoder()
            switch response.result{
                
            case .success(_):
                guard let data = response.data else { return }
                guard let cards = try? decoder.decode(Readall.self, from: data) else { return }
                
                completion(cards)
                
            case .failure(_):
                print(response.error as Any)
            }
            
        }
    
    }
}

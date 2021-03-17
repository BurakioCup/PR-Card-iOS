//
//  QRReaderPresenter.swift
//  PR-card
//
//  Created by keita on 2021/03/17.
//

import Foundation
import Alamofire

class QRReaderPresenter{
    
    var userDefaults = UserDefaults.standard
    
    func application(cardID:String,completion: @escaping (userInfoImages) -> Void) {
    
        
        
        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/read?cardID=\(cardID)") else {
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
                guard let userImages = try? decoder.decode(userInfoImages.self, from: data) else { return }
                completion(userImages)
                
            case .failure(_):
                print("error: \(response.error as Any)")
            }
            
        }
    
    }
}

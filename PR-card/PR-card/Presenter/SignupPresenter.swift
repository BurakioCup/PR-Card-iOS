//
//  SignupPresenter.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/16.
//

import Foundation
import Alamofire

class SignupPresenter{
    
    var userDefaults = UserDefaults.standard
    
//    func application(completion: @escaping (JSON) -> Void){
//
//        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/sign/up") else {
//            return
//        }
//        print(requestURL)
//
//        let parameters: HTTPHeaders =  [
//            "userID": "bbb",
//            "pass": "kaka"
//        ]
//
//        AF.request(requestURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: parameters).responseJSON { response in
//            // その完了ハンドラが渡されるのは通信完了後
//            switch response.result{
//
//            case .success(let Value):
//
//                print("----------------------------------")
//                print(JSON(Value))
//                print("----------------------------------")
//
//                completion(JSON(Value))
//
//            case .failure(_):
//                print(response.error as Any)
//            }
//
//        }
//
//    }
}

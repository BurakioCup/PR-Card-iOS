//
//  MyQRPresenter.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/17.
//

import Foundation
import Alamofire

class MyQRPresenter{

func application(completion: @escaping (QR) -> Void) {

    guard let requestURL = URL(string: "https://pr-card.herokuapp.com/read/qr") else {
        return
    }
    print(requestURL)
    
    var token = UserDefaults.standard.string(forKey: "usertoken")
    
    let parameters: HTTPHeaders = [
                "token": "\(token ?? "")"
            ]
    
    AF.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: parameters ).responseJSON { response in
        
        let decoder = JSONDecoder()
        switch response.result{
            
        case .success(_):
            guard let data = response.data else { return }
            guard let myQR = try? decoder.decode(QR.self, from: data) else { return }
            
            completion(myQR)
            
        case .failure(_):
            print(response.error as Any)
        }
        
    }
}
}

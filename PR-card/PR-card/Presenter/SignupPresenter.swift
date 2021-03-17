//
//  SignupPresenter.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/16.
//

import Foundation
import Alamofire

class SignupPresenter {
    
    var userDefaults = UserDefaults.standard
    
    func signup(){

        let userDefaults = UserDefaults.standard
        let signKey = "signup"
        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/sign/up") else {
            return
        }
        print(requestURL)
        guard let signupInfo = userDefaults.array(forKey: signKey) as? [String] else { return }

        let headers: HTTPHeaders =  [
            "userID": signupInfo[0],
            "pass": signupInfo[1]
        ]

        AF.request(requestURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            // その完了ハンドラが渡されるのは通信完了後
            switch response.result{

            case .success(_):
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                let userDefaults = UserDefaults.standard
                let tokenKey = "usertoken"
                let loginIDKey = "loginID"
                guard let signupModel = try? decoder.decode(Signup.self, from: data) else { return }
                guard let token: String = signupModel.token else { return }
                guard let loginID: String = signupModel.loginID else { return }
                userDefaults.setValue(token, forKey: tokenKey)
                userDefaults.setValue(loginID, forKey: loginIDKey)
                
                print("----------------------------------")
                print("token: \(token)")
                print("loginID: \(loginID)")
                print("----------------------------------")

            case .failure(_):
                print(response.error as Any)
            }

        }

    }
}

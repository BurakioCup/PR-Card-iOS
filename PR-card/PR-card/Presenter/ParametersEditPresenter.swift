//
//  ParametersEditPresenter.swift
//  PR-card
//
//  Created by 工藤海斗 on 2021/03/17.
//

import Alamofire
import Foundation

class ParametersEditPresenter {
    func cardOverview(itemName: [String], itemScore: [Int], completion: @escaping (Data)->Void) {
        guard let requestURL = URL(string: "https://pr-card.herokuapp.com/create/card/overview") else {
            return
        }
        print("リクエストURL：\(requestURL)")
        print("itemName：\(itemName)")
        print("itemScore：\(itemScore)")
        let userDefaults = UserDefaults.standard
        let userPhotoKey = "userPhoto"
        let tokenKey = "usertoken"
        let statusImageDataKey = "statusImage"
        guard let userPhotodata = userDefaults.string(forKey: userPhotoKey) else { return }
        
        let parameters: [String : Any] =  [
            "faceImage": userPhotodata,
            "itemName": itemName,
            "itemScore": itemScore
        ]
        
        let header: HTTPHeaders = ["token": "\(userDefaults.string(forKey: tokenKey) ?? "")"]
        
        AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            let decoder = JSONDecoder()
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                guard let faceAndStatus = try? decoder.decode(FaceAndStatus.self, from: data) else { return }
                guard let faceImageUrl = URL(string: (faceAndStatus.faceImage!)) else { return }
                guard let statusImageUrl = URL(string: (faceAndStatus.statusImage!)) else { return }
                
                do {
                    let faceImageData = try Data(contentsOf: faceImageUrl)
                    let statusImageData = try Data(contentsOf: statusImageUrl)
                    userDefaults.setValue(statusImageData, forKey: statusImageDataKey)
                    userDefaults.synchronize()
                    completion(statusImageData)
                } catch let err {
                    print(err)
                }
                
                
                print("----------------------------------")
                print("token: \(response)")
                print("----------------------------------")

            case .failure(_):
                print("エラー：",response.error as Any)
            }
        }
    }
}

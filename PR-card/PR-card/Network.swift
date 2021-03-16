//
//  Network.swift
//  PR-card
//
//  Created by 鳥山英峻 on 2021/03/16.
//

import Foundation
import Alamofire

class Network {
    static func alamofireExample() -> Void
        {
            Alamofire.request(
                .GET,
                "https://pr-vard.herokuapp.com/",
                parameters: [
                    "action": "query",
                    "format": "json",
                    "meta": "tokens",
                    "type": "login"
                ]).responseJSON { response in

                    if let JSON = response.result.value {

                        if let loginTokenKey = JSON.objectForKey("query")?.objectForKey("tokens")?.objectForKey("logintoken") {
                            print(loginTokenKey)
                        }else{
                            print("Error to parse JSON")
                        }

                    }else{
                        print("Error with response")
                    }
            }
        }
}

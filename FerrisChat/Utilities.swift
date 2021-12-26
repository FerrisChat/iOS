//
// Created by valkyrie_pilot on 12/26/21.
// Copyright (c) 2021 ferris.chat. All rights reserved.
//

import Alamofire
import SwiftyJSON


var auth_headers: HTTPHeaders = ["Authorization": token]
func get_me(token: String, completion: @escaping (Result<String, AFError>) -> Void) {
    AF.request(api_root + "auth", method: .get, headers: auth_headers).validate().responseJSON { response in
        switch response.result {
        case .success(let value):

            let json = JSON(value)
            completion(Result<String, AFError>.success(json["id_string"].stringValue))

        case .failure(let error):
            completion(Result<String, AFError>.failure(error))

        }
    }
}
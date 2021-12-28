//
// Created by valkyrie_pilot on 12/26/21.
// Copyright (c) 2021 ferris.chat. All rights reserved.
//

import Alamofire
import SwiftyJSON


func get_me(token: String, completion: @escaping (Result<JSON, AFError>) -> Void) {
    let auth_headers: HTTPHeaders = ["Authorization": token]
    AF.request(api_root + "users/me", method: .get, headers: auth_headers).validate().responseJSON { response in
        switch response.result {
        case .success(let value):
            completion(Result<JSON, AFError>.success(JSON(response.data)))

        case .failure(let error):
            completion(Result<JSON, AFError>.failure(error))

        }
    }
}

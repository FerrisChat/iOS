// <FerrisChat Apple iOS client>
// Copyright (C) 2021  valkyrie_pilot & FerrisChat Team

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Alamofire
import SwiftyJSON
import KeychainSwift


func login(email: String, password: String, completion: @escaping (Result<String, AFError>) -> Void) {
    let auth_data: [String:String] = [
        "email": email,
        "password": password,
]
    AF.request(api_root + "auth", method: .post, parameters: auth_data, encoding: JSONEncoding.default).validate().responseJSON { response in
        switch response.result {
        case .success(let value):

            let json = JSON(value)
            completion(Result<String, AFError>.success(json["token"].stringValue))

        case .failure(let error):
            completion(Result<String, AFError>.failure(error))

        }
    }
}

func signup(username: String, email: String, password: String, completion: @escaping (Result<JSON, AFError>) -> Void) {
    let create_account_json: [String: String] = [
        "username": username,
        "email": email,
        "password": password
    ]
    AF.request(api_root + "users", method: .post, parameters: create_account_json, encoder: JSONParameterEncoder.default).validate().responseJSON { response in
        debugPrint(response.debugDescription)
        switch response.result {
        case .success(let value as [String: Any]):
            let json = JSON(value)
            completion(Result<JSON, AFError>.success(json))

        case .failure(let error):
            completion(Result<JSON, AFError>.failure(error))

        default:
            fatalError("received non-dictionary JSON response")
        }
    }
}
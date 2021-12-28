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

import Foundation
import Starscream
import Alamofire
import SwiftUI
import KeychainSwift

struct MainView: View {
    @State var token: String
    @State private var userInfo: String = ""
    var body: some View {
        get_me(token: token) { result in
            debugPrint(result)
            switch result {
            case .failure(let error):
                switch error.responseCode {
                case 401:
                    KeychainSwift().delete("Token")
                    break;
                case 500:
                    userInfo = "FerrisChat failure!"
                    break;
                default:
                    userInfo = "An unexpected error (\(String(error.responseCode ?? 0))+) occurred!";

                }
                debugPrint(error)

            case .success(let json):
                debugPrint(json)
                userInfo = "Welcome \(json["name"].stringValue)#\(String(format: "%04d", json["discriminator"].int16Value)) "
            }
        }
        return Text(userInfo)
    }
}
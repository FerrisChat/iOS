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
    @Binding var token: String
    var ferrischat_response: String
    init() {
        get_me(token: token) { result in
            switch result {
            case .failure(let error):
                switch error.responseCode {
                case 500:
                    ferrischat_response = "FerrisChat failure!";
                    break;
                default:
                    ferrischat_response = "An unexpected error occurred!";

                }
                debugPrint(error)

            case .success(let json):
                debugPrint(json)
                ferrischat_response = "ha worky"//"Created account \(json["name"])#\(json["discriminator"]), ID \(json["id_string"])"
            }
        }
    }
    var body: some View {

        Text(ferrischat_response)
    }
}
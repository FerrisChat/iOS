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


import SwiftUI
import Alamofire
import KeychainSwift
import SwiftyJSON


struct AuthView: View {
    @State var showLoginView = false
    @State var showSignUpView = false
    @State var token = (KeychainSwift().get("Token") ?? "TokenNotFound")
    var body: some View {
        if token == "TokenNotFound" {
            NavigationView {

                if #available(iOS 15.0, *) {
                    VStack {
                        Spacer()
                        Text("token:" + token) // Prevent app crashing if no token is found
                        Spacer()
                        NavigationLink(destination: LogInView(), isActive: $showLoginView) {
                            Text("Log In")
                        }
                                .padding(.bottom, 10)
                        NavigationLink(destination: SignUpView(), isActive: $showSignUpView) {
                            Text("Sign Up")
                        }
                                .padding(.top, 10)
                        Spacer()
                    }
                            .buttonStyle(.borderedProminent)
                } else {
                    VStack {
                        NavigationLink(destination: LogInView(), isActive: $showLoginView) {
                            Text("Log In")
                        }
                                .padding(.bottom, 10)
                        NavigationLink(destination: SignUpView(), isActive: $showSignUpView) {
                            Text("Sign Up")
                        }
                                .padding(.top, 10)
                    }
                }
            }
        } else {
            MainView(token: token)
        }
    }
}


struct LogInView: View {
    @State private var ferrischat_email: String = ""
    @State private var ferrischat_password: String = ""
    @State private var ferrischat_response: String = ""
    var body: some View {
        Group {
            TextField(" FerrisChat Email ", text: $ferrischat_email) // these spaces are a nasty hack to make the borders look better
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            SecureField(" FerrisChat Password ", text: $ferrischat_password)
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

            Button("Login") {
                ferrischat_response = ""
                login(email: ferrischat_email, password: ferrischat_password) { result in
                    switch result {
                    case .failure(let error):
                        switch error.responseCode {
                        case 401:
                            ferrischat_response = "Username or password incorrect!";
                            break;
                        case 500:
                            ferrischat_response = "FerrisChat failure!";
                            break;
                        default:
                            ferrischat_response = "An unexpected error occurred!";

                        }
                        debugPrint(error)

                    case .success(let reply):
                        debugPrint(reply)
                        let keychain = KeychainSwift()
                        keychain.set(reply, forKey: "Token")
                        MainView(token: reply)
                    }
                }

            }
        }
                .font(Font.system(size: 30))

        Text(ferrischat_response)
                .foregroundColor(.red)
                .padding()
    }
}


struct SignUpView: View {
    @State private var ferrischat_username: String = ""
    @State private var ferrischat_email: String = ""
    @State private var ferrischat_password: String = ""
    @State private var ferrischat_password_encore: String = ""
    @State private var ferrischat_response: String = ""
    @State private var ferrischat_response_color: Color = .red
    var body: some View {
        Group {
            TextField(" Username ", text: $ferrischat_username) // these spaces are a nasty hack to make the borders look better
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            TextField(" Email ", text: $ferrischat_email)
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            SecureField(" Password ", text: $ferrischat_password)
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            SecureField(" Re-Enter Password ", text: $ferrischat_password_encore)
                    .fixedSize()
                    .border(Color.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            Button("Create Account") {
                if ferrischat_password != ferrischat_password_encore {
                    ferrischat_response = "Passwords are not the same."
                    return
                }
                ferrischat_response = "Loading...."
                signup(username: ferrischat_username, email: ferrischat_email, password: ferrischat_password, completion: { result in
                    switch result {
                    case .failure(let error):
                        switch error.responseCode {
                        case 500:
                            ferrischat_response = "FerrisChat failure!";
                            break;
                        case 409:
                            ferrischat_response = "Email already registered."
                            break;
                        default:
                            ferrischat_response = "An unexpected error occurred!";

                        }
                        debugPrint(error)

                    case .success(let json):
                        debugPrint(json)
                        ferrischat_response = "Created account \(json["name"])#\(json["discriminator"]), ID \(json["id"])"
                        ferrischat_response_color = .green
                    }
                })
            }
            Text(ferrischat_response)
                    .foregroundColor(ferrischat_response_color)
                    .padding(20)
                    .multilineTextAlignment(.center)
                    .font(Font.system(size: 15))
        }
                .font(Font.system(size: 30))
    }
}

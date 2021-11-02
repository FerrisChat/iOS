//
//  ContentView.swift
//  FerrisChat
//
//  Created by valkyrie_pilot on 10/24/21.
//

import SwiftUI
import CoreData
import Alamofire
import SwiftyJSON

func login(email: String, password: String, completion: @escaping (Result<Any, AFError>) -> Void) {
    let auth_headers: HTTPHeaders = [
        "Email": email,
        "Password": password,
        "Content-Type": "application/json"
    ]
    AF.request(api_root + "auth", method: .post, headers: auth_headers).validate().responseJSON { response in
        switch response.result {
        case .success(let value):

            let json = JSON(value)
            completion(Result<Any, AFError>.success(json))

        case .failure(let error):
            completion(Result<Any, AFError>.failure(error))

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

struct ContentView: View {
    @State var showLoginView = false
    @State var showSignUpView = false
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                VStack {
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
    }
}


struct LogInView: View {
    @State private var ferrischat_email: String = ""
    @State private var ferrischat_password: String = ""
    @State private var ferrischat_response: String = ""
    var body: some View {
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

                case .success(let value):
                    debugPrint(value)
                    ferrischat_response = "Logged in! Going further is WIP."
                }
            }
        }

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
//
//  ContentView.swift
//  FerrisChat
//
//  Created by Grant Hutchinson on 10/24/21.
//

import SwiftUI
import CoreData
import Alamofire

func login(email: String, password: String, completion: ()->()) -> String {
    var finalResponse: String = "something went wrong"
    let auth_headers: HTTPHeaders = [
        "Email": email,
        "Password": password
    ]
    AF.request(api_root + "auth", method: .post, headers: auth_headers).validate().responseData { response in
        switch response.result {
        case .success:
            
            finalResponse = String(data: response.data!, encoding: .utf8)!
        case let .failure(error):
            finalResponse = error.localizedDescription
        }
        }
    
    completion()
    return finalResponse
}
    

struct ContentView: View {
    @State private var ferrischat_email: String = ""
    @State private var ferrischat_password: String = ""
    var body: some View {
        TextField(" FerrisChat Email ", text: $ferrischat_email) // these spaces are a nasty hack to make the borders look better
            .fixedSize()
            .border(Color.gray)
        TextField(" FerrisChat Password ", text: $ferrischat_password)
            .fixedSize()
            .border(Color.gray)
        Button("Login") {
            let token = login(email: ferrischat_email, password: ferrischat_password, completion: {
                print(token)})
        }
        
    }
}

struct PostLogin: View {
    var body: some View {
        Text("Successfully logged in!")
    }
}
	

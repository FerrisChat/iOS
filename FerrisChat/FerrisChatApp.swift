//
//  FerrisChatApp.swift
//  FerrisChat
//
//  Created by valkyrie_pilot on 10/24/21.
//

import SwiftUI

let api_root: String = "https://ferris.chat/api/v0/"

@main
struct FerrisChatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

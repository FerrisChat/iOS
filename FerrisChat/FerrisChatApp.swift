//
//  FerrisChatApp.swift
//  FerrisChat
//
//  Created by Grant Hutchinson on 10/24/21.
//

import SwiftUI

@main
struct FerrisChatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

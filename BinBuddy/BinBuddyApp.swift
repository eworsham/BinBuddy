//
//  BinBuddyApp.swift
//  BinBuddy
//
//  Created by Ryan Worsham on 7/23/25.
//

import SwiftUI
import SwiftData

@main
struct BinBuddyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContainerListView()
        }
        .modelContainer(sharedModelContainer)
    }
}

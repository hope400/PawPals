//
//  PawPalsApp.swift
//  PawPals
//
//  Created by user286283 on 2/4/26.
//
import SwiftUI
import FirebaseCore  // ← Add this import

@main
struct PawPalsApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var appState = AppState()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(appState)
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
        }
    }
}

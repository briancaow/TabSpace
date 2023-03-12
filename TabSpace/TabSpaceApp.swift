//
//  TabSpaceApp.swift
//  TabSpace
//
//  Created by Brian Cao on 2/25/23.
//

import SwiftUI
import Foundation
import Cocoa
import KeyboardShortcuts

@main
struct TabSpaceApp: App {
    // For recording keyboard shortcuts
    @StateObject private var appState = AppState()
    // Core Data
    static var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .frame(width: 500, height: 250)
//        }
//        .windowResizability(.contentSize)
        
        MenuBarExtra("TabSpace", systemImage: "wand.and.stars") {
            MenuBarView()
                .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
        }
        
    }
    
}

@MainActor
final class AppState: ObservableObject {
    init() {
//        KeyboardShortcuts.onKeyUp(for: .toggleUnicornMode) { [self] in
//            isUnicornMode.toggle()
//        }
    }
}

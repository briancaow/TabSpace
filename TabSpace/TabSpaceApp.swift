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
    
    private let workspace = NSWorkspace.shared
    
    init() {
        let request: NSFetchRequest<Space> = Space.fetchRequest()

        let spaces = try! TabSpaceApp.persistenceController.container.viewContext.fetch(request)
        for space in spaces {
            let name = space.name!
            KeyboardShortcuts.Name.spaces[name] = KeyboardShortcuts.Name(name)
        }

    }
    
    var body: some Scene {
        
        MenuBarExtra("TabSpace", systemImage: "wand.and.stars") {
            MenuBarView()
                .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
        }
        
    }
    
}

@MainActor
final class AppState: ObservableObject {
    
    private let workspace = NSWorkspace.shared
     
    init() {

        KeyboardShortcuts.onKeyUp(for: .clearDesktop) { [self] in
            workspace.hideOtherApplications()
            //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
        }

    }
}

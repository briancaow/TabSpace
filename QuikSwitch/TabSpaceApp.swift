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
import AppKit

@main
struct TabSpaceApp: App {
    
    // For recording keyboard shortcuts
    private var appState = AppState()
    
    // Core Data
    static var persistenceController = PersistenceController.shared
    
    private let workspace = NSWorkspace.shared
    
    init() {
        // Fetch all the spaces
        let request: NSFetchRequest<Space> = Space.fetchRequest()
        let spaces = try! TabSpaceApp.persistenceController.container.viewContext.fetch(request)
        
        // Registering a name for each shortcut and at functionality to each shortcut
        for space in spaces {
            let id: UUID = space.id!
            KeyboardShortcuts.Name.spaces[id.uuidString] = KeyboardShortcuts.Name(id.uuidString)
            KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name.spaces[id.uuidString]!) { [self] in
                // Hide old stuff
                let finderBundleIdentifier = "com.apple.finder"
                NSWorkspace.shared.runningApplications
                    .filter { $0.bundleIdentifier != finderBundleIdentifier }
                    .forEach {$0.hide()}
                // Open New stuff
                let tabs: Set<Tab> = space.tabs as! Set<Tab>
                
                for tab in tabs {
                    workspace.open(URL(fileURLWithPath: tab.urlPath!))
                }
                                
                //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))

            }
        }

    }
    
    var body: some Scene {
        
        MenuBarExtra("TabSpace", systemImage: "wand.and.stars") {
            MenuBarView()
                .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
        }
        
    }
    
}


final class AppState {
    
    private let workspace = NSWorkspace.shared
     
    init() {

        KeyboardShortcuts.onKeyUp(for: .clearDesktop) {
            // Hide old stuff
            let finderBundleIdentifier = "com.apple.finder"
            NSWorkspace.shared.runningApplications
                .filter { $0.bundleIdentifier != finderBundleIdentifier }
                .forEach {$0.hide()}
            //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
        }
        KeyboardShortcuts.onKeyUp(for: .editSpaces) {
            MenuBarView.editSpaces()
        }
        

    }
}

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
    
    
    
    init() {
        let request: NSFetchRequest<Space> = Space.fetchRequest()
        
        let spaces = try! TabSpaceApp.persistenceController.container.viewContext.fetch(request)
        for space in spaces {
            let name = space.name!
            KeyboardShortcuts.Name.spaces[name] = KeyboardShortcuts.Name(name)
        }
        print(KeyboardShortcuts.Name.spaces)
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
        let request: NSFetchRequest<Space> = Space.fetchRequest()
        
        let spaces = try! TabSpaceApp.persistenceController.container.viewContext.fetch(request)
        
        KeyboardShortcuts.onKeyUp(for: .clearDesktop) { [self] in
            workspace.hideOtherApplications()
        }
        
        for space in spaces {
            let name = space.name!
            KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name.spaces[name]!) { [self] in
                // Hide all other tabs
                workspace.hideOtherApplications()

                // Open tabspace
                let tabs: Set<Tab> = space.tabs as! Set<Tab>
                for tab in tabs {

                    workspace.open(URL(fileURLWithPath: tab.urlPath!))
                        
                }
            }
        }
        
    }
}

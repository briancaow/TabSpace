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
        // Fetch all the spaces
        let request: NSFetchRequest<Space> = Space.fetchRequest()
        let spaces = try! TabSpaceApp.persistenceController.container.viewContext.fetch(request)
        
        // Registering a name for each shortcut and at functionality to each shortcut
        for space in spaces {
            let id: UUID = space.id!
            KeyboardShortcuts.Name.spaces[id.uuidString] = KeyboardShortcuts.Name(id.uuidString)
            KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name.spaces[id.uuidString]!) { [self] in
                // Hide all other tabs
                for app in workspace.runningApplications {
                    app.hide()
                }

                // Code to be executed after a 1-second delay
                // Open tabspace
                let tabs: Set<Tab> = space.tabs as! Set<Tab>
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) {
                    for tab in tabs {
                        // Code to be executed after a delay
                        workspace.open(URL(fileURLWithPath: tab.urlPath!))
                    }
                        
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

@MainActor
final class AppState: ObservableObject {
    
    private let workspace = NSWorkspace.shared
     
    init() {

        KeyboardShortcuts.onKeyUp(for: .clearDesktop) { [self] in
            workspace.hideOtherApplications()
            //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
        }
        KeyboardShortcuts.onKeyUp(for: .editSpaces) { [self] in
            MenuBarView.editSpaces()
        }
        

    }
}

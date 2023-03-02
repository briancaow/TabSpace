//
//  TabSpaceApp.swift
//  TabSpace
//
//  Created by Brian Cao on 2/25/23.
//

import SwiftUI
import Foundation
import Cocoa

@main
struct TabSpaceApp: App {
    // Core Data
    var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .frame(width: 220, height: 100)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                
        }
        .windowResizability(.contentSize)
        
        MenuBarExtra("TabSpace", systemImage: "wand.and.stars") {
            MenuBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
    }
    
}
//            Button("School") {
//
//                // Launch Calendar and Notes applications
//                let notionURL = URL(fileURLWithPath: "/Applications/Notion.app")
//                let remnoteURL = URL(fileURLWithPath: "/Applications/RemNote.app")
//                let arcURL = URL(fileURLWithPath: "/Applications/Arc.app")
//                let calURL = URL(fileURLWithPath: "/System/Applications/Calendar.app")
//                let remindersURL = URL(fileURLWithPath: "/System/Applications/Reminders.app")
//
//                workspace.hideOtherApplications()
//
//                workspace.open(notionURL)
//                workspace.open(remnoteURL)
//                workspace.open(arcURL)
//                workspace.open(calURL)
//                workspace.open(remindersURL)
//
//            }
//            Button("Coding") {
//                let xcodeURL = URL(fileURLWithPath: "/Applications/Xcode.app")
//                let termUrl = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")
//
//                workspace.hideOtherApplications()
//
//                workspace.open(xcodeURL)
//                workspace.open(termUrl)
//
//            }

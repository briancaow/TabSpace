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
    let workspace = NSWorkspace.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        MenuBarExtra("TabSpace", systemImage: "wand.and.stars") {
            Button("School") {

                // Launch Calendar and Notes applications
                let notionURL = URL(fileURLWithPath: "/Applications/Notion.app")
                let remnoteURL = URL(fileURLWithPath: "/Applications/RemNote.app")
                let arcURL = URL(fileURLWithPath: "/Applications/Arc.app")
                let calURL = URL(fileURLWithPath: "/System/Applications/Calendar.app")
                let remindersURL = URL(fileURLWithPath: "/System/Applications/Reminders.app")
                
                NSWorkspace.shared.hideOtherApplications()

                workspace.open(notionURL)
                workspace.open(remnoteURL)
                workspace.open(arcURL)
                workspace.open(calURL)
                workspace.open(remindersURL)
            
            }
            Button("Coding") {
                let xcodeURL = URL(fileURLWithPath: "/Applications/Xcode.app")
                let termUrl = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")

                NSWorkspace.shared.hideOtherApplications()

                workspace.open(xcodeURL)
                workspace.open(termUrl)
                   
            }
            Button("Clear") {
                NSWorkspace.shared.hideOtherApplications()
            }
            Divider()
            Button("Save Space") {
                
            }
            Divider()
            Button("Prefrences...") {
           
            }
        }
    }
}

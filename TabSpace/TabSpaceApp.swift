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
                
                workspace.hideOtherApplications()

                workspace.open(notionURL)
                workspace.open(remnoteURL)
                workspace.open(arcURL)
                workspace.open(calURL)
                workspace.open(remindersURL)
            
            }
            Button("Coding") {
                let xcodeURL = URL(fileURLWithPath: "/Applications/Xcode.app")
                let termUrl = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app")

                workspace.hideOtherApplications()

                workspace.open(xcodeURL)
                workspace.open(termUrl)
                   
            }
            Button("Clear") {
                workspace.hideOtherApplications()
            }
            Divider()
            Button("Save Space") {
                
                // Get all open windows
                let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
                let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
                let infoList = windowsListInfo as! [[String:Any]]
                let visibleWindows = infoList.filter{ $0["kCGWindowLayer"] as! Int == 0 }

                // Get all applications in space
                var applicationsInSpace: Set<String> = [];
                for window in visibleWindows {
                    print(window["kCGWindowOwnerName"]!)
                    applicationsInSpace.insert(window["kCGWindowOwnerName"]! as! String)
                }

                // Get URL of all applications in space
                var applicationURLs: Set<String> = [];
                for app in workspace.runningApplications {
                    if (applicationsInSpace.contains(app.localizedName ?? "")) {
                        applicationURLs.insert(app.bundleURL!.relativePath)
                        //print(app.bundleURL?.relativePath ?? "no path")
                    }
                    
                }
                
                for urlPath in applicationURLs {
                    print(urlPath)
                }
                
                
            }
            Divider()
            Button("Prefrences...") {
           
            }
        }
    }
}

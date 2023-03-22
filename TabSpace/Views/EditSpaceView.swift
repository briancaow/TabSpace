//
//  EditSpaceView.swift
//  QuikSwitch
//
//  Created by Brian Cao on 3/21/23.
//

import Foundation
import SwiftUI
import KeyboardShortcuts


struct EditSpaceView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var spaceName: String = ""
    
    private let workspace = NSWorkspace.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            // Clear Desktop
            HStack {
                KeyboardShortcuts.Recorder("Clear Desktop Shortcut:", name: .clearDesktop)
                
                Button("Clear Desktop") {
                    MenuBarView.clearDesktop()
                }
            }
            
            KeyboardShortcuts.Recorder("Edit Spaces Shortcut:    ", name: .editSpaces)
            
            Spacer()
            
            // How to add space text
            Text("""
            If you want to add a new Space 🪄
                > 🚀 Launch the apps you would like to add
                > ❌ Close the apps you don't want to add
                > 🤔 Pick a name for your new space
                > 🪄 Click save
            """)
            
            Spacer()
            
            // Save Space Text Field and button
            HStack {
                TextField("My New Space", text: $spaceName)
                Button("Save Space"){
                    saveSpace()
                }
                .disabled(spaceName == "")
                
                
            }
        }
        
    }
    
    private func saveSpace() {
        // Init data for space
        let space = Space(context: self.viewContext)
        space.name = spaceName
        
        // Get all open windows
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        let infoList = windowsListInfo as! [[String:Any]]
        let visibleWindows = infoList.filter{ $0["kCGWindowLayer"] as! Int == 0 }
        
        // Get all applications in space
        var applicationsInSpace: Set<String> = [];
        for window in visibleWindows {
            let appName: String = window["kCGWindowOwnerName"]! as! String
            if (!applicationsInSpace.contains(appName)) {
                applicationsInSpace.insert(appName)
                
                for app in workspace.runningApplications {
                    if (appName == app.localizedName ?? "" && appName != "TabSpace") {
                        // Got apps with open windows and URL
                        let tab = Tab(context: self.viewContext)
                        tab.name = appName
                        tab.urlPath = app.bundleURL!.relativePath

                        //print(appName)
                        //print(app.bundleURL!.relativePath)
                        let str: Dictionary = window["kCGWindowBounds"]! as! Dictionary<String, Int>
                        
                        let height: Int = str["Height"]!
                        let width: Int = str["Width"]!
                        let x: Int = str["X"]!
                        let y: Int = str["Y"]!
                        
                        tab.xPosition = Int16(x)
                        tab.yPosition = Int16(y)
                        tab.height = Int16(height)
                        tab.width = Int16(width)
                        
                        //print(str)
                        space.addToTabs(tab)
                        
                    }
                    
                }
                
            }
            
        }
        
        
        // Add Keyboard short cut
        let id = UUID()
        space.id = id
        KeyboardShortcuts.Name.spaces[id.uuidString] = KeyboardShortcuts.Name(id.uuidString)
        KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name.spaces[id.uuidString]!) {
            MenuBarView.openSpace(space: space)
        }
        
        // Save to Core Data
        try! self.viewContext.save()
        spaceName = ""
    }
}

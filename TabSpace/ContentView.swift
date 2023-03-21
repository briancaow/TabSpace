//
//  ContentView.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//

import Foundation
import SwiftUI
import CoreData
import AppKit
import KeyboardShortcuts

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    @State private var spaceName: String = ""
    
    @FetchRequest(sortDescriptors: [])
    private var spaces: FetchedResults<Space>
    
    private let workspace = NSWorkspace.shared
    
    var body: some View {
        
        HStack {
            VStack(spacing: 0) {
                Text("My Spaces 🪄")
                    .bold()
                    .padding(5)
                    .frame(width: 300)
                    .background(colorScheme == .light ? .white : .black)
                
                // List of spaces
                List(spaces) { space in
                    let name = space.name!
                    let id: UUID = space.id!
                    HStack {
                        Text(name)
                        
                        // Keyboard Shortcut recorder
                        KeyboardShortcuts.Recorder("", name: KeyboardShortcuts.Name.spaces[id.uuidString]!)
                        
                        Spacer()
                        // Trash button
                        Button() {
                            
                            //KeyboardShortcuts.disable(KeyboardShortcuts.Name.spaces[id.uuidString]!)
                            KeyboardShortcuts.reset(KeyboardShortcuts.Name.spaces[id.uuidString]!)
                            // Unregister shortcut name
                            KeyboardShortcuts.Name.spaces.removeValue(forKey: id.uuidString)

                            // Delete from core data
                            viewContext.delete(space)
                            try! viewContext.save()
                            
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        .padding(2)
                    }
                    
                }
                .frame(width: 300)
                .scrollIndicators(.never)
                
                
            }
            
            VStack(alignment: .leading) {
                HStack {
                    KeyboardShortcuts.Recorder("Clear Desktop Shortcut:", name: .clearDesktop)
                    Button("Clear Desktop") {
                        // Hide old stuff
                        let finderBundleIdentifier = "com.apple.finder"
                        NSWorkspace.shared.runningApplications
                            .filter { $0.bundleIdentifier != finderBundleIdentifier }
                            .forEach {$0.hide()}
                        
                        //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
                        
                    }
                }
                
                KeyboardShortcuts.Recorder("Edit Spaces Shortcut:    ", name: .editSpaces)
                
                Spacer()
                Text("""
                If you want to add a new Space 🪄
                    > 🚀 Launch the apps you would like to add
                    > ❌ Close the apps you don't want to add
                    > 🤔 Pick a name for your new space
                    > 🪄 Click save
                """)
                Spacer()
                HStack {
                    TextField("My New Space", text: $spaceName)
                    Button("Save Space"){
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
                        
                        // Save to Core Data
                        try! self.viewContext.save()
                        spaceName = ""
                        
                        
                    }
                    .disabled(spaceName == "")
                    
                    
                }
            }
            .padding()
            .frame(minWidth: 450)
        }
        .frame(minHeight: 200)
        
            
    }
    
}



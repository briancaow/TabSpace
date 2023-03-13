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
                
                List(spaces) { space in
                    let name = space.name!
                    HStack {
                        Text(name)
                        
                        // Keyboard Shortcut recorder
                        KeyboardShortcuts.Recorder("", name: KeyboardShortcuts.Name(name))
                        
                        Spacer()
                        // Trash button
                        Button() {
                            viewContext.delete(space)
                            try! viewContext.save()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    
                }
                .frame(width: 300)
                .scrollIndicators(.never)
                
                
            }
            
            VStack {
                    
                KeyboardShortcuts.Recorder("Clear Desktop Shortcut:", name: .clearDesktop)
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
                        // Init data
                        let space = Space(context: self.viewContext)
                        space.name = spaceName
                        
                        // Keyboard short cut
                        KeyboardShortcuts.onKeyUp(for: KeyboardShortcuts.Name(space.name!)) { [self] in
                            // Hide all other tabs
                            workspace.hideOtherApplications()
            
                            // Code to be executed after a 1-second delay
                            // Open tabspace
                            let tabs: Set<Tab> = space.tabs as! Set<Tab>
                            for tab in tabs {
            
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    // Code to be executed after a 2 second delay
                                    workspace.open(URL(fileURLWithPath: tab.urlPath!))
                                }
            
                            }
                            
                            //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
            
                        }
                        
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

                                        print(appName)
                                        print(app.bundleURL!.relativePath)
                                        let str: Dictionary = window["kCGWindowBounds"]! as! Dictionary<String, Int>
                                        
                                        let height: Int = str["Height"]!
                                        let width: Int = str["Width"]!
                                        let x: Int = str["X"]!
                                        let y: Int = str["Y"]!
                                        
                                        tab.xPosition = Int16(x)
                                        tab.yPosition = Int16(y)
                                        tab.height = Int16(height)
                                        tab.width = Int16(width)
                                        
                                        print(str)
                                        space.addToTabs(tab)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        try! self.viewContext.save()
                        
                        
                        
                    }
                    .disabled(spaceName == "")
                    
                    
                }
            }
            .padding()
            .frame(minWidth: 350)
        }
        .frame(minHeight: 200)
            
    }
    
}



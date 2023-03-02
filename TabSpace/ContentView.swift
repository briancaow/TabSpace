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

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var spaceName: String = ""
    
    @FetchRequest(sortDescriptors: [])
    private var spaces: FetchedResults<Space>
    
    private let workspace = NSWorkspace.shared
    
    var body: some View {
        VStack{
            TextField("New Space Name", text: $spaceName)
                .frame(maxWidth: 200)
            Button("Save Space"){
                // Init data
//                let space = Space()
//                space.name = spaceName
//                var tabs: Set<Tab>
                
                
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
                            if (appName == app.localizedName ?? "") {
                                // Got apps with open windows and URL
//                                var tab = Tab()
//                                tab.name = appName
//                                tab.urlPath = app.bundleURL!.relativePath
//                                tab.xPosition = window.
                                print(appName)
                                print(app.bundleURL!.relativePath)
                                print(window)
                                //print(app)
                            
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                
                
            }
            .disabled(spaceName == "")
        }
        
    }
    
}

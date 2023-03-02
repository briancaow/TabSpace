//
//  ContentView.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//

import Foundation
import SwiftUI
import CoreData

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
                // Get all open windows
                let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
                let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
                let infoList = windowsListInfo as! [[String:Any]]
                let visibleWindows = infoList.filter{ $0["kCGWindowLayer"] as! Int == 0 }
                
                // Get all applications in space
                var applicationsInSpace: Set<String> = [];
                for window in visibleWindows {
                    applicationsInSpace.insert(window["kCGWindowOwnerName"]! as! String)
                }
                
                // Get URL of all applications in space
                var applicationURLs: Set<String> = [];
                for app in workspace.runningApplications {
                    if (applicationsInSpace.contains(app.localizedName ?? "")) {
                        applicationURLs.insert(app.bundleURL!.relativePath)
                    }
                    
                }
                
                
                // Print all apps
                for app in applicationsInSpace {
                    print(app)
                }
                
                // Print all URL paths
                for urlPath in applicationURLs {
                    print(urlPath)
                }
                
                
            }
            .disabled(spaceName == "")
        }
    }
}

//
//  MenuBar.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//

import Foundation
import SwiftUI

struct MenuBarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var spaces: FetchedResults<Space>

    private let workspace = NSWorkspace.shared
   
    
    var body: some View {
        VStack{
            ForEach(spaces, id: \.self) { space in
                Button("\(space.name!)") {

                    // Hide all other tabs
                    workspace.hideOtherApplications()

                    // Open tabspace
                    let tabs: Set<Tab> = space.tabs as! Set<Tab>
                    for tab in tabs {

                        workspace.open(URL(fileURLWithPath: tab.urlPath!))
                            
                    }
                }
            }
            
            Button("Clear Desktop") {
                workspace.hideOtherApplications()
            }
            
            Divider()
            
            Button("Edit Spaces") {
                workspace.openApplication(at:
                    URL(fileURLWithPath: "/Users/briancao/Library/Developer/Xcode/DerivedData/TabSpace-artbskfyyhbgtdboioabhbhcfhmk/Build/Products/Debug/TabSpace.app"),
                    configuration: NSWorkspace.OpenConfiguration())
            }
            
            Divider()
            
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
        
        
    }
    

}

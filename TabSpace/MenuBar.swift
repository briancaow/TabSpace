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
            List(spaces) { space in
                Button(space.name ?? "Unknown") {
                    print(space.tabs?.count ?? "default value")
                }
            }
            Button("Clear") {
                workspace.hideOtherApplications()
            }
            Divider()
            
            Button("Save Space") {
                workspace.openApplication(at:
                    URL(fileURLWithPath: "/Users/briancao/Library/Developer/Xcode/DerivedData/TabSpace-artbskfyyhbgtdboioabhbhcfhmk/Build/Products/Debug/TabSpace.app"),
                    configuration: NSWorkspace.OpenConfiguration())
            }
            
            Divider()
            Button("Prefrences...") {
           
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
        
        
    }
}

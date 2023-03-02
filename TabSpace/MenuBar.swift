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
            Button("Clear") {
                workspace.hideOtherApplications()
            }
            Divider()
            
            Button("Save Space") {
                
                
                
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

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
   
    private var editWindow:NSWindow? = nil
    
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
                let contentView = ContentView().environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
                let view = NSHostingView(rootView: contentView)
                let viewController = NSViewController()
                viewController.view = view
                
                let newWindow = NSWindow(contentViewController: viewController)
                newWindow.title = "TabSpace"
                newWindow.makeKeyAndOrderFront(nil)
                
            }.keyboardShortcut("e")
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
            

        }
        
        
    }
    

}

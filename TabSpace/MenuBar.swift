//
//  MenuBar.swift
//  TabSpace
//
//  Created by Brian Cao on 3/1/23.
//

import Foundation
import SwiftUI
import KeyboardShortcuts

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
                    workspace.hideOtherApplications()
                    workspace.hideOtherApplications()

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
                    
            }
            
            Button("Clear Desktop") {
                workspace.hideOtherApplications()
                //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
            }
            
            Divider()
            
            Button("Edit Spaces") {
                let contentView = ContentView().environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
                let view = NSHostingView(rootView: contentView)
                let viewController = NSViewController()
                viewController.view = view
                
                if let existingWindow = NSApplication.shared.windows.first(where: { $0.title == "TabSpace" }) {
                    // the window already exists, bring it to the front
                    existingWindow.contentViewController = viewController
                    existingWindow.makeKeyAndOrderFront(nil)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                } else {
                    // create a new window
                    let newWindow = NSWindow(contentViewController: viewController)
                    newWindow.title = "TabSpace"
                    newWindow.makeKeyAndOrderFront(nil)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
                
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
            

        }
        
        
        
    }
    

}

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
   
    
    public static func editSpaces() {
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
    
    var body: some View {
        
        VStack{
            // Buttons for Spaces
            ForEach(spaces, id: \.self) { space in
                
                Button("\(space.name!)") {

                    for app in workspace.runningApplications {
                        app.hide()
                    }


                    // Open tabspace
                    let tabs: Set<Tab> = space.tabs as! Set<Tab>
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) {
                        for tab in tabs {
                            // Code to be executed after a delay
                            workspace.open(URL(fileURLWithPath: tab.urlPath!))
                        }
                            
                    }
                    
                    //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
                }
                    
            }
            
            Button("Clear Desktop") {
                for app in workspace.runningApplications {
                    app.hide()
                }
                //workspace.open(URL(fileURLWithPath: "/Applications/KeyCastr.app"))
            }
            
            Divider()
            
            Button("Edit Spaces") {
                MenuBarView.editSpaces()
                
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
            

        }
        
        
        
    }
    

}

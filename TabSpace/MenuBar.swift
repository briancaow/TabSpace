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

                        // This code will be executed after a delay of 1 second
                        workspace.open(URL(fileURLWithPath: tab.urlPath!))
 
                        // This code will be executed after a delay of 1 second
                        if let window = NSApplication.shared.keyWindow {
                            // do something with window
                            let x: Int = Int(tab.xPosition)
                            let y: Int = Int(tab.yPosition)
                            let width: Int = Int(tab.width)
                            let height: Int = Int(tab.height)
                            
                            let frame = NSRect(x: x, y: y, width: width, height: height)
                            window.setFrame(frame, display: true)
                        }
                            
                    }
                }
            }
            Button("Delete All Spaces") {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Space")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                do {
                    print("deleting all spaces")
                    try viewContext.persistentStoreCoordinator?.execute(deleteRequest, with: viewContext)
                } catch let error as NSError {
                    // TODO: handle the error
                    print(error)
                }
            }
            Button("Clear") {
                workspace.hideOtherApplications()
            }
            Divider()
            
            Button("Prefrences...") {
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

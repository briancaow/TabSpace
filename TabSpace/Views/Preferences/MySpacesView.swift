//
//  MySpaces.swift
//  QuikSwitch
//
//  Created by Brian Cao on 3/21/23.
//

import Foundation
import SwiftUI
import KeyboardShortcuts


struct MySpacesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: [])
    private var spaces: FetchedResults<Space>
    
    @State var showAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("My Workspaces 🪄")
                .bold()
                .padding(5)
                .frame(width: 400)
                .background(colorScheme == .light ? .white : Color(nsColor: NSColor(red: 0.11764706, green: 0.11764706, blue: 0.11764706, alpha: 1)))
            
            // List of spaces
            List(spaces) { space in
                let name = space.name!
                let id: UUID = space.id!
                HStack {
                    Text(name)
                    
                    // Keyboard Shortcut recorder
                    KeyboardShortcuts.Recorder("", name: KeyboardShortcuts.Name.spaces[id.uuidString]!)
                    
                    Spacer()
                    
                    // Update Space Button
                    Button() {
                        print("Update to match")
                        // Unregister shortcut name
                        KeyboardShortcuts.reset(KeyboardShortcuts.Name.spaces[id.uuidString]!)
                        KeyboardShortcuts.Name.spaces.removeValue(forKey: id.uuidString)

                        // Delete from core data
                        viewContext.delete(space)
                        try! viewContext.save()
                        
                        // Save new space
                        EditSpaceView.saveSpace(spaceName: name, context: viewContext)
                        
                        showAlert = true
                    } label: {
                        Image(systemName: "arrow.down.square")
                    }
                    
                    // Trash button
                    Button() {
                        // Unregister shortcut name
                        KeyboardShortcuts.reset(KeyboardShortcuts.Name.spaces[id.uuidString]!)
                        KeyboardShortcuts.Name.spaces.removeValue(forKey: id.uuidString)

                        // Delete from core data
                        viewContext.delete(space)
                        try! viewContext.save()
                        
                        
                    } label: {
                        Image(systemName: "trash")
                    }
                    .padding(2)
                }
                
            }
            .scrollIndicators(.never)
            
            
        }
        .frame(width: 400)
        .alert("Updated Workspace to Match!", isPresented: $showAlert) {
            //Button("OK", role: .cancel) { }
        }
        
    }
}

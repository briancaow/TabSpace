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
import KeyboardShortcuts

struct ContentView: View {

    @State private var selection = 0
    
    var body: some View {
        
            TabView(selection: $selection) {
                HStack {
                    MySpacesView()
                        .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
                        .padding(5)
                    
                    EditSpaceView()
                        .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
                        .padding()
                        
                }
                
                .tabItem{
                    Text("Edit Spaces")
                }
                .tag(0)
                
                VStack(alignment: .leading){
                    Text("""
                    Hello everyone! it's Brian 👋😄,
                    
                    I'm a 2nd year computer science student from the University of Washington that loves to build! My dream is to make enough to travel the world while creating software. Thank you so much for using QuikSwitch and for being part of my journey towards achieving my dreams!
                    
                    If you would like to follow me and keep up to date with other projects I'm working on check out briancao.me and follow @BrianCaoo on twitter!
                    
                    Thats all thank you!
                    
                    - Brian 👋
                    
                    """)
                }
                .tabItem{
                    Text("About Me!")
                }
                .tag(1)
                
                
            }
            .frame(width: 750, height: 300)
            .padding(7)
            
            
            
        
        
            
    }
    
}



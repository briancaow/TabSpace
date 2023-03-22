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

    var body: some View {
        
        HStack {
            
            MySpacesView()
                .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
            
            EditSpaceView()
                .environment(\.managedObjectContext, TabSpaceApp.persistenceController.container.viewContext)
                .padding()
                .frame(width: 450)
            
            
        }
        .frame(height: 250)
        
            
    }
    
}



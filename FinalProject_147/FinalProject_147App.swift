//
//  FinalProject_147App.swift
//  FinalProject_147
//
//  Created by User20 on 2020/12/22.
//

import SwiftUI

@main
struct FinalProject_147App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            //MainView()
                
        }
    }
}

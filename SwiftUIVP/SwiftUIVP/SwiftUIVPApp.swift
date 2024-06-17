//
//  SwiftUIVPApp.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 16/06/24.
//

import SwiftUI

@main
struct SwiftUIVPApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  SwiftUIVPApp.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 16/06/24.
//

import SwiftUI

@main
struct SwiftUIVPApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(context: PersistenceController.shared.container.viewContext)
        }
    }
}

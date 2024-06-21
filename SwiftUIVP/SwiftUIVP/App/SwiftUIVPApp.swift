//
//  SwiftUIVPApp.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 16/06/24.
//

import SwiftUI

@main
struct SwiftUIVPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SharedStatus())
        }
    }
}

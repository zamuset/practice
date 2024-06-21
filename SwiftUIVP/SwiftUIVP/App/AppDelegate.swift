//
//  AppDelegate.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Start network connectivity monitoring
        NetworkMonitor.shared.startMonitoring()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (success, error) in
            if error == nil {
                if success {
                    // In case you want to register for the remote notifications
                    Task { @MainActor in
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("Permission denied")
                }
            } else {
                debugPrint(error?.localizedDescription)
            }
        }
            
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceController.shared.saveContext()
    }
}

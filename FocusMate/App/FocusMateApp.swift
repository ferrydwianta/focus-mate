//
//  FocusMateApp.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI
import UserNotifications
import OSLog

@main
struct FocusMateApp: App {
    @State private var notificationService = NotificationService()
    
    init() {
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(notificationService: $notificationService)
        } label: {
            Label("FocusMate", systemImage: "circle.dotted.circle.fill")
        }
        .menuBarExtraStyle(.window)
        .windowResizability(.contentSize)
        
        Window("Notifications Permission", id: "notificationsWindow") {
            NotificationPermissionView {
                NotificationService().openSystemSettings()
            }
            .frame(width: 340, height: 150)
        }
        .windowResizability(.contentSize)
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    
    private let logger = Logger(subsystem: "com.yourcompany.FocusMate", category: "Notifications")
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        logger.debug("willPresent called for notification: \(notification.request.identifier)")
        return [.banner, .list, .sound, .badge]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async { }
}

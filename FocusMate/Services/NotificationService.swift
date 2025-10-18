import Foundation
import UserNotifications
import AppKit

@Observable
class NotificationService {
    /// Requests notification authorization with alert, sound, and badge options.
    /// - Throws: An error if the user denies authorization.
    func requestAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let granted = try await center.requestAuthorization(options: options)
        if !granted {
            throw AuthorizationError.denied
        }
    }
    
    /// Schedules a local notification with the given title and body, triggered after 0.1 seconds.
    /// - Parameters:
    ///   - title: The notification title.
    ///   - body: The notification body.
    func send(title: String, body: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
    
    /// Checks current notification authorization status; requests authorization if not authorized.
    /// - Returns: A Boolean indicating whether notifications are authorized.
    func ensureAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied, .notDetermined:
            do {
                try await requestAuthorization()
                return true
            } catch {
                return false
            }
        @unknown default:
            return false
        }
    }
    
    func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.Notifications-Settings.extension") {
            NSWorkspace.shared.open(url)
            return
        }
        if let url = URL(string: "x-apple.systempreferences:") {
            NSWorkspace.shared.open(url)
        }
    }
    
    enum AuthorizationError: Error {
        case denied
    }
}

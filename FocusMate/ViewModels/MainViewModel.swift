//
//  MainViewModel.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

@Observable
class MainViewModel {
    var notificationService: NotificationService
    var focusStarted: Bool = false

    init(notificationService: NotificationService = NotificationService()) {
        self.notificationService = notificationService
    }

    /// Starts focus and posts a local notification.
    func startFocus() {
        withAnimation { focusStarted = true }
        Task {
            let title = "Focus started"
            let body = "When you start focus mode, the app quietly tracks your computer activity (keystrokes and app changes) to help you stay aware and productive."
            await notificationService.send(title: title, body: body)
        }
    }

    /// Stops focus and posts a local notification.
    func stopFocus() {
        withAnimation { focusStarted = false }
        Task {
            let title = "Focus stopped"
            let body = "Focus mode has ended."
            await notificationService.send(title: title, body: body)
        }
    }

    /// Toggles focus state and triggers corresponding actions.
    func toggleFocus() {
        if focusStarted {
            stopFocus()
        } else {
            startFocus()
        }
    }
}

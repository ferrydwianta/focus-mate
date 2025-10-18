//
//  ContentView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var notificationService: NotificationService
    
    @Environment(\.openWindow) private var openWindow
    @State private var hasCheckedAuth = false
    
    var body: some View {
        MainView()
            .task {
                guard !hasCheckedAuth else { return }
                hasCheckedAuth = true
                let authorized = await notificationService.ensureAuthorization()
                if !authorized {
                    openWindow(id: "notificationsWindow")
                }
            }
    }
}

#Preview {
    ContentView(notificationService: .constant(NotificationService()))
}

//
//  ContentView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var hasCheckedAuth = false
    
    var body: some View {
        MainView()
            .task {
                guard !hasCheckedAuth else { return }
                hasCheckedAuth = true
                
                let notificationsGranted = await NotificationService.ensureAuthorization()
                if !notificationsGranted {
                    openWindow(id: "notificationsWindow")
                }
                
                _ = ActivityMonitorService.isInputMonitoringAuthorized()
            }
    }
}

#Preview {
    ContentView()
}

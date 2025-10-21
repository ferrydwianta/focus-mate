//
//  AppActivationTrackerService.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 21/10/25.
//

import Foundation
import AppKit

struct AppActivation {
    let bundleID: String?
    let appName: String
    let timestamp: Date
}

final class AppActivationTrackerService {
    private var tokens: [NSObjectProtocol] = []
    private(set) var activations: [AppActivation] = []
    private var running = false
    
    func start() {
        guard !running else { return }
        running = true
        activations.removeAll()
        
        let nc = NSWorkspace.shared.notificationCenter
        
        // Detect when app is launched
        tokens.append(nc.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil, queue: .main
        ) { [weak self] n in
            guard let self,
                  let app = n.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  !isMenuBarOrAgent(app)
            else { return }
            self.record(app: app)
        })
        
        // Detect when app is brought to front
        tokens.append(nc.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil, queue: .main
        ) { [weak self] n in
            guard let self,
                  let app = n.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
                  !isMenuBarOrAgent(app)
            else { return }
            self.record(app: app)
        })
    }
    
    func stop() {
        guard running else { return }
        running = false
        tokens.forEach(NotificationCenter.default.removeObserver)
        tokens.removeAll()
    }
    
    func recordCurrentActivation() {
        if let app = NSWorkspace.shared.frontmostApplication, !isMenuBarOrAgent(app) {
            record(app: app)
        }
    }
    
    private func record(app: NSRunningApplication) {
        activations.append(
            AppActivation(
                bundleID: app.bundleIdentifier,
                appName: app.localizedName ?? "Unknown",
                timestamp: Date()
            )
        )
    }
    
    func reset() {
        activations.removeAll()
    }
    
    func isMenuBarOrAgent(_ app: NSRunningApplication) -> Bool {
        if let url = app.bundleURL, let bundle = Bundle(url: url),
           let info = bundle.infoDictionary {
            if let uiEl = (info["LSUIElement"] as? NSNumber)?.boolValue, uiEl { return true }
            if let bg = (info["LSBackgroundOnly"] as? NSNumber)?.boolValue, bg { return true }
        }
        return false
    }
}

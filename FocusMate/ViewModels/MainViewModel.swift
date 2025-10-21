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
    var storageService: StorageService
    var activityMonitor: ActivityMonitorService
    var appActivationTracker: AppActivationTrackerService
    var focusStarted: Bool = false
    var elapsedText: String = "00 hrs 00 m 00 s"
    var keyboardCount: Int = 0
    var mouseClickCount: Int = 0
    
    private var timer: Timer?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    
    init(
        notificationService: NotificationService = NotificationService(),
        storageService: StorageService = StorageService(),
        activityMonitor: ActivityMonitorService = ActivityMonitorService(),
        appActivationTracker: AppActivationTrackerService = AppActivationTrackerService()
    ) {
        self.notificationService = notificationService
        self.storageService = storageService
        self.activityMonitor = activityMonitor
        self.appActivationTracker = appActivationTracker
        
        activityMonitor.onUpdate = { [weak self] key, mouse in
            guard let self else { return }
            self.keyboardCount = key
            self.mouseClickCount = mouse
        }
    }
    
    func startFocus() {
        guard !focusStarted else { return }
        resetElapsed()
        
        startDate = Date()
        withAnimation { focusStarted = true }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateElapsedText()
        }
        timer?.fire()
        
        activityMonitor.reset()
        activityMonitor.start()
        
        appActivationTracker.reset()
        appActivationTracker.start()
        appActivationTracker.recordCurrentActivation()
        
        Task {
            let title = "Focus started"
            let body = "When you start focus mode, the app quietly tracks your computer activity (keystroke and click counts) to help you stay aware and productive."
            await notificationService.send(title: title, body: body)
        }
    }
    
    func stopFocus() {
        guard focusStarted else { return }
        
        let end = Date()
        var sessionStart: Date? = nil
        if let start = startDate {
            accumulatedTime += end.timeIntervalSince(start)
            sessionStart = start
        }
        let duration = accumulatedTime
        
        activityMonitor.stop()
        let counts = activityMonitor.snapshotCounts()
        
        let activations = appActivationTracker.activations
        appActivationTracker.stop()
        
        if let sessionStart {
            storageService.saveSession(
                start: sessionStart,
                end: end,
                duration: duration,
                keyboardCount: counts.keyboard,
                mouseClickCount: counts.mouse,
                activations: activations
            )
        }
        
        startDate = nil
        timer?.invalidate()
        timer = nil
        
        updateElapsedText()
        
        withAnimation { focusStarted = false }
        
        Task {
            await notificationService.send(
                title: "Focus stopped",
                body: "Session saved."
            )
        }
    }
    
    func toggleFocus() {
        focusStarted ? stopFocus() : startFocus()
    }
    
    private func updateElapsedText() {
        let runningTime = startDate.map { Date().timeIntervalSince($0) } ?? 0
        let total = accumulatedTime + runningTime
        elapsedText = total.elapsedText()
    }
    
    func resetElapsed() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulatedTime = 0
        updateElapsedText()
        keyboardCount = 0
        mouseClickCount = 0
        appActivationTracker.reset()
    }
}

// TODO: show data using Dictionary(grouping: session.activations, by: \.appName)

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
    var elapsedText: String = "00 hrs 00 m 00 s"
    
    private var timer: Timer?
    private var startDate: Date?
    private var accumulatedTime: TimeInterval = 0
    
    init(notificationService: NotificationService = NotificationService()) {
        self.notificationService = notificationService
    }
    
    func startFocus() {
        guard !focusStarted else { return }
        resetElapsed()
        
        startDate = Date()
        withAnimation { focusStarted = true }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateElapsedText()
        }
        timer?.fire()
        
        Task {
            let title = "Focus started"
            let body = "When you start focus mode, the app quietly tracks your computer activity (keystrokes and app changes) to help you stay aware and productive."
            await notificationService.send(title: title, body: body)
        }
    }
    
    func stopFocus() {
        guard focusStarted else { return }
        
        if let start = startDate {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        startDate = nil
        
        timer?.invalidate()
        timer = nil
        
        updateElapsedText()
        
        withAnimation { focusStarted = false }
        
        Task {
            let title = "Focus stopped"
            let body = "Focus mode has ended."
            await notificationService.send(title: title, body: body)
        }
    }
    
    func toggleFocus() {
        if focusStarted {
            stopFocus()
        } else {
            startFocus()
        }
    }
    
    private func updateElapsedText() {
        let runningTime: TimeInterval
        if let start = startDate {
            runningTime = Date().timeIntervalSince(start)
        } else {
            runningTime = 0
        }
        
        let total = accumulatedTime + runningTime
        let hours = Int(total) / 3600
        let minutes = (Int(total) % 3600) / 60
        let seconds = Int(total) % 60
        
        let formatted: String
        if hours > 0 {
            formatted = String(format: "%02d hrs %02d m %02d s", hours, minutes, seconds)
        } else {
            formatted = String(format: "%02d m %02d s", minutes, seconds)
        }
        elapsedText = formatted
    }
    
    func resetElapsed() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulatedTime = 0
        updateElapsedText()
    }
}


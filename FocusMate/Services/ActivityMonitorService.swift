//
//  ActivityMonitorService.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import Cocoa

final class ActivityMonitorService {
    private var keyTap: CFMachPort?
    private var mouseTap: CFMachPort?
    private var keyRunLoopSrc: CFRunLoopSource?
    private var mouseRunLoopSrc: CFRunLoopSource?
    private let lock = NSLock()
    
    private(set) var keyboardCount: Int = 0
    private(set) var mouseClickCount: Int = 0
    
    var onUpdate: ((Int, Int) -> Void)?
    
    func start() {
        guard Self.isInputMonitoringAuthorized() else {
            AppLogger.error("Input Monitoring not authorized. Start aborted.", category: .permissions)
            return
        }
        setupKeyTap()
        setupMouseTap()
    }
    
    func stop() {
        if let src = keyRunLoopSrc { CFRunLoopRemoveSource(CFRunLoopGetCurrent(), src, .commonModes) }
        if let src = mouseRunLoopSrc { CFRunLoopRemoveSource(CFRunLoopGetCurrent(), src, .commonModes) }
        if let tap = keyTap { CFMachPortInvalidate(tap) }
        if let tap = mouseTap { CFMachPortInvalidate(tap) }
        keyRunLoopSrc = nil
        mouseRunLoopSrc = nil
        keyTap = nil
        mouseTap = nil
    }
    
    func reset() {
        lock.lock()
        keyboardCount = 0
        mouseClickCount = 0
        lock.unlock()
        onUpdate?(0, 0)
    }
    
    func snapshotCounts() -> (keyboard: Int, mouse: Int) {
        lock.lock()
        let k = keyboardCount
        let m = mouseClickCount
        lock.unlock()
        return (k, m)
    }
    
    // MARK: - Private
    private func setupKeyTap() {
        let mask = (1 << CGEventType.keyDown.rawValue)
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: CGEventMask(mask),
            callback: { proxy, type, event, refcon in
                guard type == .keyDown else { return Unmanaged.passUnretained(event) }
                let unmanagedSelf = Unmanaged<ActivityMonitorService>.fromOpaque(refcon!)
                let me = unmanagedSelf.takeUnretainedValue()
                me.incrementKeyboard()
                return Unmanaged.passUnretained(event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) else {
            AppLogger.error("Key tap could not be created. Likely missing Input Monitoring permission.", category: .permissions)
            return
        }
        keyTap = tap
        keyRunLoopSrc = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), keyRunLoopSrc, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
    
    private func setupMouseTap() {
        let events: [CGEventType] = [.leftMouseDown, .rightMouseDown, .otherMouseDown]
        var mask: CGEventMask = 0
        for e in events { mask |= (1 << e.rawValue) }
        
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: mask,
            callback: { proxy, type, event, refcon in
                switch type {
                case .leftMouseDown, .rightMouseDown, .otherMouseDown:
                    let unmanagedSelf = Unmanaged<ActivityMonitorService>.fromOpaque(refcon!)
                    let me = unmanagedSelf.takeUnretainedValue()
                    me.incrementMouse()
                default: break
                }
                return Unmanaged.passUnretained(event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        ) else {
            AppLogger.error("Mouse tap could not be created. Likely missing Input Monitoring permission.", category: .permissions)
            return
        }
        mouseTap = tap
        mouseRunLoopSrc = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), mouseRunLoopSrc, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
    
    private func incrementKeyboard() {
        lock.lock()
        keyboardCount &+= 1
        let k = keyboardCount
        let m = mouseClickCount
        lock.unlock()
        DispatchQueue.main.async { [weak self] in self?.onUpdate?(k, m) }
    }
    
    private func incrementMouse() {
        lock.lock()
        mouseClickCount &+= 1
        let k = keyboardCount
        let m = mouseClickCount
        lock.unlock()
        DispatchQueue.main.async { [weak self] in self?.onUpdate?(k, m) }
    }
}

extension ActivityMonitorService {
    static func isInputMonitoringAuthorized() -> Bool {
        let mask = (1 << CGEventType.keyDown.rawValue)
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: CGEventMask(mask),
            callback: { _,_, event, _ in
                return Unmanaged.passUnretained(event)
            },
            userInfo: nil
        ) else {
            return false
        }
        
        let src = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), src, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        CFMachPortInvalidate(tap)
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), src, .commonModes)
        return true
    }
    
    static func openSystemSettingsForInputMonitoring() {
        let candidates = [
            "x-apple.systempreferences:com.apple.settings.Privacy-InputMonitoring",
            // Older System Preferences deep link:
            "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent",
            // Privacy root as last resort:
            "x-apple.systempreferences:com.apple.preference.security?Privacy",
            "x-apple.systempreferences:"
        ]
        for raw in candidates {
            if let url = URL(string: raw), NSWorkspace.shared.open(url) { return }
        }
    }
}

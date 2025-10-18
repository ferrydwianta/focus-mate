//
//  TimeInterval+Ext.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import Foundation

extension TimeInterval {
    func elapsedText() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        
        let formatted: String
        if hours > 0 {
            formatted = String(format: "%02d hrs %02d m %02d s", hours, minutes, seconds)
        } else {
            formatted = String(format: "%02d m %02d s", minutes, seconds)
        }
        return formatted
    }
}

//
//  FocusSessionRow.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 21/10/25.
//

import SwiftUI

struct FocusSessionRow: View {
    let session: FocusSessionEntity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "timer")
                .imageScale(.large)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(session.startTime.dateRange(to: session.endTime))
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text(session.startTime.timeRange(to: session.endTime))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 8)
            
            Text(session.duration.elapsedText())
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(.quaternary)
                )
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FocusSessionRow(session: FocusSessionEntity.example)
}

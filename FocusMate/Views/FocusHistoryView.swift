//
//  FocusHistoryView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

struct FocusHistoryView: View {
    @State private var viewModel = FocusHistoryViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.sessions.isEmpty {
                ContentUnavailableView(
                    "No focus sessions yet",
                    systemImage: "timer",
                    description: Text("Start a session to see your history here.")
                )
                .padding()
            } else {
                List {
                    Section {
                        ForEach(viewModel.sessions, id: \.id) { session in
                            SessionRow(session: session)
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .navigationTitle("History")
        .onAppear { viewModel.loadSessions() }
    }
}

private struct SessionRow: View {
    let session: FocusSessionEntity
    @Environment(\.colorScheme) private var scheme
    
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
    NavigationStack {
        FocusHistoryView()
            .frame(width: 360, height: 460)
    }
}

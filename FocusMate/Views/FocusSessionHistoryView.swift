//
//  FocusHistoryView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI
import Foundation

struct FocusSessionHistoryView: View {
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
                            NavigationLink(destination: FocusDetailView(session: session)) {
                                FocusSessionRow(session: session)
                            }
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

#Preview {
    NavigationStack {
        FocusSessionHistoryView()
            .frame(width: 360, height: 460)
    }
}

//
//  FocusDetailView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 21/10/25.
//

import SwiftUI

struct FocusDetailView: View {
    let session: FocusSessionEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GroupBox {
                FocusSessionRow(session: session)
                    .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            
            let apps = session.activations
            GroupBox {
                VStack(alignment: .leading, spacing: 4) {
                    if apps.isEmpty {
                        Text("No app activity recorded.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(apps, id: \.self) { app in
                            HStack {
                                Text(app.appName)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("x\(app.timestamps.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                        }
                    }
                }
                .padding(8)
            } label: {
                let title = "Apps Opened (" + "\(apps.count)" + ")"
                Label(title, systemImage: "list.bullet")
                    .labelStyle(.titleOnly)
            }
        }
        .padding()
        .navigationTitle("Session Detail")
    }
}


#Preview {
    NavigationStack {
        FocusDetailView(session: FocusSessionEntity.example)
            .frame(width: 360, height: 460)
    }
}

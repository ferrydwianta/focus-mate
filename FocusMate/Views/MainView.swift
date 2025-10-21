//
//  MainView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @State private var isShowingHistory = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("FocusMate")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Button { isShowingHistory = true } label: {
                        Label("History", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                    .controlSize(.large)
                }
                
                if viewModel.focusStarted {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(viewModel.elapsedText)
                                .font(.largeTitle)
                            
                            Text("Current Session")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 2)
                            
                            Text("Keyboard: \(viewModel.keyboardCount) taps")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("Mouse: \(viewModel.mouseClickCount) clicks")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("Apps Opened: \(viewModel.appActivationTracker.activations.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Button {
                    viewModel.toggleFocus()
                } label: {
                    Text(viewModel.focusStarted ? "Stop Focus" : "Start Focus")
                        .font(.title2)
                        .frame(maxWidth: .infinity, minHeight: 42)
                        .background(viewModel.focusStarted ? .red : .indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationDestination(isPresented: $isShowingHistory) {
                FocusSessionHistoryView()
            }
        }
    }
}

#Preview {
    MainView()
        .frame(width: 340, height: 440)
}

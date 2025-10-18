//
//  MainView.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("FocusMate")
                    .font(.system(size: 22, weight: .bold))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Label("History", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .controlSize(.large)
            }
            
            Spacer()
            
            if viewModel.focusStarted {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("01 hrs 00 m")
                            .font(.largeTitle)
                        
                        Text("Current Session")
                            .font(.caption)
                            .padding(.bottom, 4)
                        
                        Text("Keyboard: 120 types")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("Mouse: 73 clicks")
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
                    .background(viewModel.focusStarted ? Color.red : Color.indigo)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    MainView()
        .frame(width: 300, height: 400)
}

//
//  PreferencePaneView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
import ServiceManagement

struct PreferencePaneView: View {
    @State private var isLaunchAtLoginEnabled = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        TabView {
            Form {
                Section(header: Text("Application").font(.title)) {
                    Toggle("Launch at Login", isOn: $isLaunchAtLoginEnabled)
                        .onChange(of: isLaunchAtLoginEnabled) {
                            toggleLaunchAtLogin(enabled: isLaunchAtLoginEnabled)
                        }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data Management")
                            .font(.headline)
                        
                        Button(action: clearCounts) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Clear Launch History")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        
                        Text("This will permanently delete all launch count data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
        }
        .frame(width: 500, height: 280)
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func toggleLaunchAtLogin(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            alertMessage = "Failed to update login settings: \(error.localizedDescription)"
            showAlert = true
            isLaunchAtLoginEnabled.toggle()
        }
    }
    
    private func clearCounts() {
        LaunchCountsManager().clear()
        alertMessage = "Launch history has been cleared"
        showAlert = true
    }
}

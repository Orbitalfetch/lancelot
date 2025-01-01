//
//  LaunchAtLoginToggle.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
import ServiceManagement

struct LaunchAtLoginToggle: View {
    @Binding var isEnabled: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    var body: some View {
        Toggle("Launch at Login", isOn: $isEnabled)
            .onChange(of: isEnabled) {
                toggleLaunchAtLogin(enabled: isEnabled)
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
        }
    }
}

//
//  GeneralSettingsView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Binding var savedPaths: String
    @EnvironmentObject var keybindManager: KeybindManager
    
    var body: some View {
        Form {
            Section(header: Text("Application").font(.title)) {
                LaunchAtLoginToggle(showAlert: $showAlert, alertMessage: $alertMessage)
                Divider()
                KeyboardShortcutSection()
                DataManagementSection(savedPaths: $savedPaths)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

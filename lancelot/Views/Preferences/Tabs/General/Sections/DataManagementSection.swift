//
//  DataManagementSection.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct DataManagementSection: View {
    @Binding var savedPaths: String
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Data Management")
                .font(.headline)
            
            DataManagementButtons(savedPaths: $savedPaths, showAlert: $showAlert, alertMessage: $alertMessage)
        }
        .padding(.vertical, 4)
    }
}

struct DataManagementButtons: View {
    @Binding var savedPaths: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                savedPaths = "[\"/Applications\"]"
                alertMessage = "Paths have been reset to default"
                showAlert = true
            }) {
                HStack {
                    Image(systemName: "questionmark.folder")
                    Text("Reset Paths")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            Button(action: {
                LaunchCountsManager().clear()
                alertMessage = "Launch history has been cleared"
                showAlert = true
            }) {
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
    }
}

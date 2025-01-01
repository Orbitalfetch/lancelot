//
//  AddPathField.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct AddPathField: View {
    @Binding var newPath: String
    @Binding var paths: [String]
    let onSave: () -> Void
    
    var body: some View {
        HStack {
            TextField("Add new path", text: $newPath)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .bold()
            
            Button("Add") {
                if !newPath.isEmpty {
                    paths.append(newPath)
                    newPath = ""
                    onSave()
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .disabled(newPath.isEmpty)
            .foregroundColor(.accentColor)
        }
    }
}

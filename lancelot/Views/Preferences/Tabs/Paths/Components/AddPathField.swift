//
//  AddPathField.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
import AppKit

struct AddPathField: View {
    @Binding var newPath: String
    @Binding var paths: [String]
    let onSave: () -> Void
    @State private var isShowingPicker = false
    
    var body: some View {
        HStack {
            TextField("Add new path", text: $newPath)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .bold()
            
            Button("Browse...") {
                showFolderPicker()
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button("Add") {
                if !newPath.isEmpty {
                    if !paths.contains(newPath) {
                        paths.append(newPath)
                    }
                    newPath = ""
                    onSave()
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .disabled(newPath.isEmpty)
            .bold()
            .foregroundColor(!newPath.isEmpty ? .accentColor : .gray)
        }
    }
    private func showFolderPicker() {
        let picker = NSOpenPanel()
        picker.title = "Choose a folder"
        picker.canChooseDirectories = true
        picker.canChooseFiles = false
        picker.allowsMultipleSelection = false
        
        if picker.runModal() == .OK {
            if let url = picker.url {
                let accessing = url.startAccessingSecurityScopedResource()
                
                do {
                    let bookmarkData = try url.bookmarkData(
                        options: .withSecurityScope,
                        includingResourceValuesForKeys: nil,
                        relativeTo: nil
                    )
                    
                    UserDefaults.standard.set(bookmarkData, forKey: "FolderBookmark-\(url.path)")
                    
                    paths.append(newPath)
                    onSave()
                } catch {
                    print("failed to create bookmark :", error)
                }
                
                if accessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
        }
    }
}

//
//  PathSettingsView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct PathSettingsView: View {
    @Binding var savedPaths: String
    @State private var paths: [String] = []
    @State private var newPath: String = ""
    @State private var editingIndex: Int? = nil
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("Paths").font(.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    PathList(paths: $paths, editingIndex: $editingIndex, onSave: savePaths)
                    AddPathField(newPath: $newPath, paths: $paths, onSave: savePaths)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear(perform: loadPaths)
    }
    
    private func savePaths() {
        if let data = try? JSONEncoder().encode(paths) {
            savedPaths = String(data: data, encoding: .utf8) ?? "[]"
        }
    }
    
    public func loadPaths() {
        if let data = savedPaths.data(using: .utf8),
           let decodedPaths = try? JSONDecoder().decode([String].self, from: data) {
            paths = decodedPaths
        }
    }
}

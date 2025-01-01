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
    @EnvironmentObject var keybindManager: KeybindManager
    @Binding var savedPaths: String
    @State private var paths: [String] = []
    @State private var newPath: String = ""
    @State private var editingIndex: Int? = nil
    
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
                        Text("Keyboard Shortcuts")
                            .font(.headline)
                        
                        HStack {
                            Text("Toggle app:")
                            Spacer()
                            Text(getKeybindString())
                                .foregroundColor(.secondary)
                            KeyRecorderView(isRecording: $keybindManager.isRecordingKeybind) { key, modifiers in
                                keybindManager.saveKeybind(key: key, modifiers: modifiers)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    
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
            
            Form {
                Section(header: Text("Edit Paths").font(.title2)) {
                    List {
                        ForEach(paths.indices, id: \.self) { index in
                            if editingIndex == index {
                                HStack {
                                    TextField("Edit Path", text: Binding(
                                        get: { paths[index] },
                                        set: { paths[index] = $0 }
                                    ))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
                                    Button("Save") {
                                        savePaths()
                                        editingIndex = nil
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            } else {
                                HStack {
                                    Text(paths[index])
                                    Spacer()
                                    Button("Edit") {
                                        editingIndex = index
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    Button("Delete") {
                                        paths.remove(at: index)
                                        savePaths()
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    HStack {
                        TextField("Add new path", text: $newPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Add") {
                            if !newPath.isEmpty {
                                paths.append(newPath)
                                newPath = ""
                                savePaths()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(newPath.isEmpty)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .tabItem {
                Label("Paths", systemImage: "folder.badge.gearshape")
            }
        }
        .frame(width: 500, height: 280)
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear(perform: loadPaths)
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
    
    private func getKeybindString() -> String {
        let modifierString = keybindManager.currentModifiers.description
        let keyString = keybindManager.currentKey.description
        return "\(modifierString) + \(keyString)"
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

//
//  ContentView.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI
import AppKit

struct BlurryEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        effectView.blendingMode = .behindWindow
        effectView.material = .sidebar  // You can adjust the material
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var allApps: [AppModel] = []
    @State private var filteredApps: [AppModel] = []
    @State private var selectedIndex = 0
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        ZStack {
            BlurryEffect()
                .ignoresSafeArea()

            VStack {
                TextField("Search for apps...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isSearchFieldFocused)
                    .onChange(of: searchText) {
                        filterApps(searchText)
                        selectedIndex = 0
                    }
                    .onSubmit {
                        if !filteredApps.isEmpty {
                            launchApp(filteredApps[selectedIndex])
                        }
                    }
                
                if filteredApps.isEmpty {
                    Spacer()
                    Image(systemName: "app.dashed")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 48))
                        .padding(.bottom, 8)
                    Text("No apps found.")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                } else {
                    List(filteredApps.indices, id: \.self) { index in
                        Text(filteredApps[index].name)
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(index == selectedIndex ? Color.accentColor.opacity(0.3) : Color.clear)
                                .padding(.horizontal, 4)
                        )
                        .onTapGesture {
                            selectedIndex = index
                            launchApp(filteredApps[index])
                        }
                    }
                    .scrollContentBackground(.hidden) // Ensures List background is transparent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .onAppear {
            loadApplications()
            isSearchFieldFocused = true
        }
        .frame(minWidth: 400, minHeight: 400)
        .onKeyPress(.upArrow) {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
            return .handled
        }
        .onKeyPress(.downArrow) {
            if selectedIndex < filteredApps.count - 1 {
                selectedIndex += 1
            }
            return .handled
        }
    }
    
    private func launchApp(_ app: AppModel) {
        let url = NSURL(fileURLWithPath: app.path, isDirectory: true) as URL
        
        let path = "/zsh"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }
    // Load all applications
    private func loadApplications() {
        let applicationsPath = "/Applications"
        let fileManager = FileManager.default

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
            allApps = contents
                .filter { $0.hasSuffix(".app") }
                .map { appName in
                    let fullPath = (applicationsPath as NSString).appendingPathComponent(appName)
                    return AppModel(
                        name: (appName as NSString).deletingPathExtension,
                        path: fullPath,
                        iconPath: ""  // TODO: icon handling
                    )
                }
            filteredApps = allApps
        } catch {
            print("Error loading applications: \(error)")
        }
    }

    // Filter applications based on search text
    private func filterApps(_ query: String) {
        if query.isEmpty {
            filteredApps = allApps
        } else {
            filteredApps = allApps.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
    }
}

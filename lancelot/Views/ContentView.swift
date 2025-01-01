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
        effectView.material = .sidebar
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var allApps: [AppModel] = []
    @State private var filteredApps: [AppModel] = []
    @State private var selectedIndex = 0
    @FocusState private var isSearchFieldFocused: Bool
    
    @State private var iconLoader = Iconloader()
    
    // Using AppStorage to persist app launch counts
    @Binding var appLaunchCountsJSON: String
    @State private var appLaunchCounts: [String: Int] = [:]

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
                        HStack {
                            IconView(imgPath: filteredApps[index].iconPath)
                            Text(filteredApps[index].name)
                        }
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
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .onAppear {
            loadApplications()
            loadLaunchCounts()
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
        
        // Update the launch count for the app
        appLaunchCounts[app.name, default: 0] += 1
        saveLaunchCounts()

        let path = "/zsh"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
    }
    
    private func loadApplications() {
        let applicationsPath = "/Applications"
        let fileManager = FileManager.default

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
            allApps = contents
                .filter { $0.hasSuffix(".app") }
                .map { appName in
                    let fullPath = (applicationsPath as NSString).appendingPathComponent(appName)
                    return AppModel(name: (appName as NSString).deletingPathExtension, path: fullPath, iconPath: iconLoader.getIcnsPath(fullPath))
                }
            filteredApps = allApps.sorted {
                appLaunchCounts[$0.name, default: 0] > appLaunchCounts[$1.name, default: 0]
            }
        } catch {
            print("Error loading applications: \(error)")
        }
    }

    private func loadLaunchCounts() {
        if let data = appLaunchCountsJSON.data(using: .utf8),
           let decodedCounts = try? JSONDecoder().decode([String: Int].self, from: data) {
            appLaunchCounts = decodedCounts
        } else {
            appLaunchCounts = [:]
        }
        // Sort the apps after loading counts
        filteredApps = allApps.sorted {
            appLaunchCounts[$0.name, default: 0] > appLaunchCounts[$1.name, default: 0]
        }
    }


    private func filterApps(_ query: String) {
        if query.isEmpty {
            filteredApps = allApps.sorted {
                appLaunchCounts[$0.name, default: 0] > appLaunchCounts[$1.name, default: 0]
            }
        } else {
            filteredApps = allApps.filter {
                $0.name.lowercased().contains(query.lowercased())
            }.sorted {
                appLaunchCounts[$0.name, default: 0] > appLaunchCounts[$1.name, default: 0]
            }
        }
    }

    private func saveLaunchCounts() {
        if let data = try? JSONEncoder().encode(appLaunchCounts),
           let jsonString = String(data: data, encoding: .utf8) {
            appLaunchCountsJSON = jsonString
        }
    }
}

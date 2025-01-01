//
//  ContentView.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI
import AppKit

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
                SearchBarView(searchText: $searchText, isSearchFieldFocused: $isSearchFieldFocused, onFilter: { query in
                    filterApps(query)
                    selectedIndex = 0
                }, onSubmit: {
                    if !filteredApps.isEmpty {
                        launchApp(filteredApps[selectedIndex])
                    }
                })
                if filteredApps.isEmpty {
                    AppEmptyStateView()
                } else {
                    AppsListView(filteredApps: $filteredApps, iconLoader: iconLoader, selectedIndex: $selectedIndex, onAppSelected: { app in
                        launchApp(app)
                    })
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

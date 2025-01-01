//
//  ContentView.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI
import HotKey

struct ContentView: View {
    let showControl = ShowControl()
    @EnvironmentObject var keybindManager: KeybindManager
    @State private var hotKey: HotKey?
    
    @State private var searchText = ""
    @StateObject private var launchCountsManager = LaunchCountsManager()
    @State private var allApps: [AppModel] = []
    @State private var filteredApps: [AppModel] = []
    @State private var selectedIndex = 0
    @FocusState private var isSearchFieldFocused: Bool
    
    @State private var iconLoader = Iconloader()
    
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
                    .padding(.top, 5)
                }
            }
            .padding()
            .padding(.top, -10)
        }
        .frame(minWidth: 400, minHeight: 400)
        .onAppear {
            showControl.firstPlan()
            setupHotkey()
            loadApplications()
            launchCountsManager.loadLaunchCounts()
            filterApps(searchText)
            isSearchFieldFocused = true
        }
        .onChange(of: keybindManager.currentKey) {
            setupHotkey()
        }
        .onChange(of: keybindManager.currentModifiers) {
            setupHotkey()
        }
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
        launchCountsManager.incrementLaunchCount(for: app.name)

        let path = "/zsh"
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = [path]
        NSWorkspace.shared.openApplication(at: url,
                                           configuration: configuration,
                                           completionHandler: nil)
        showControl.hide()
    }
    
    private func setupHotkey() {
        if let existingHotKey = hotKey {
            existingHotKey.isPaused = true
        }
        
        hotKey = HotKey(key: keybindManager.currentKey, modifiers: keybindManager.currentModifiers.hotKeyModifiers)
        hotKey?.keyDownHandler = {
            if NSApplication.shared.isHidden {
                searchText = ""
                loadApplications()
                filterApps("")
                showControl.unhide()
            } else {
                showControl.hide()
            }
        }
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
        } catch {
            print("Error loading applications: \(error)")
        }
    }


    private func filterApps(_ query: String) {
        if query.isEmpty {
            filteredApps = allApps.sorted {
                launchCountsManager.appLaunchCounts[$0.name, default: 0] >
                launchCountsManager.appLaunchCounts[$1.name, default: 0]
            }
        } else {
            filteredApps = allApps.filter {
                $0.name.lowercased().contains(query.lowercased())
            }.sorted {
                launchCountsManager.appLaunchCounts[$0.name, default: 0] >
                launchCountsManager.appLaunchCounts[$1.name, default: 0]
            }
        }
    }
}

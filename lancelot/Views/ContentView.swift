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
    
    @Binding var savedPaths: String
    @Binding var showPaths: Bool
    
    var body: some View {
        ZStack {
            BlurryEffect()
                .ignoresSafeArea()

            VStack {
                SearchBarView(searchText: $searchText, isSearchFieldFocused: $isSearchFieldFocused, onFilter: { query in
                    filterApps(query)
                    selectedIndex = 0
                }, onSubmit: {
                    if searchText.hasPrefix("@google") {
                        let query = searchText.dropFirst(8).trimmingCharacters(in: .whitespaces)
                        guard let url = URL(string: "https://www.google.com/search?q=\(query)") else { return }
                        NSWorkspace.shared.open(url)
                    }
                    else if !filteredApps.isEmpty {
                        launchApp(filteredApps[selectedIndex])
                    }
                })
                if searchText.hasPrefix("@google") {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(
                            .linearGradient(
                                colors: [
                                    Color(red: 219/255, green: 68/255, blue: 55/255),
                                    Color(red: 219/255, green: 68/255, blue: 55/255),
                                    Color(red: 244/255, green: 180/255, blue: 0/255),
                                    Color(red: 66/255, green: 133/255, blue: 244/255),
                                    Color(red: 15/255, green: 157/255, blue: 88/255)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .font(.system(size: 48))
                        .padding(.bottom, 8)
                    Text("Search \"\(searchText.dropFirst(8).trimmingCharacters(in: .whitespaces))\" on Google...")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                } else if filteredApps.isEmpty {
                    AppEmptyStateView()
                } else {
                    AppsListView(filteredApps: $filteredApps, iconLoader: iconLoader, selectedIndex: $selectedIndex, onAppSelected: { app in
                        launchApp(app)
                    }, showPaths: $showPaths)
                    .padding(.top, 5)
                }
            }
            .padding()
            .padding(.top, -10)
        }
        .frame(minWidth: 500, minHeight: 140)
        .onAppear {
            if !lancelotApp.hideWindow {
                showControl.firstPlan()
            }

            setupHotkey()
            loadApplications()
            launchCountsManager.loadLaunchCounts()
            filterApps(searchText)
            isSearchFieldFocused = true
            if lancelotApp.hideWindow {
                showControl.hide()
            }
        }
        .onChange(of: keybindManager.currentKey) {
            setupHotkey()
        }
        .onChange(of: keybindManager.currentModifiers) {
            setupHotkey()
        }
        .onChange(of: keybindManager.isRecordingKeybind) {
            hotKey?.isPaused = keybindManager.isRecordingKeybind
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
        .onKeyPress(.escape) {
            if !keybindManager.isRecordingKeybind {
                if searchText.isEmpty {
                    showControl.hide()
                }
                else {
                    searchText = ""
                }
            }
            return .handled
        }
    }
    
    private func launchApp(_ app: AppModel) {
        let url = NSURL(fileURLWithPath: app.path, isDirectory: true) as URL
        
        // Update the launch count for the app
        launchCountsManager.incrementLaunchCount(for: app.name)

        let configuration = NSWorkspace.OpenConfiguration()
        configuration.arguments = []
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
        allApps = []
        let fileManager = FileManager.default
        let allPaths: [String] = try! JSONDecoder().decode([String].self, from: savedPaths.data(using: .utf8)!)
        
        for applicationPath in allPaths {
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: applicationPath)
                allApps += contents
                    .filter { $0.hasSuffix(".app") }
                    .map { appName in
                        let fullPath = (applicationPath as NSString).appendingPathComponent(appName)
                        return AppModel(name: (appName as NSString).deletingPathExtension, path: fullPath, icon: iconLoader.getIconNew(fullPath))
                    }
            } catch {
                print("Error loading applications: \(error)")
            }
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

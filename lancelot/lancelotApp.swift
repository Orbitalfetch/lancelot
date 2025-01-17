//
//  lancelotApp.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI

@main
struct lancelotApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var keybindManager = KeybindManager()
    @AppStorage("showPaths") var showPaths: Bool = false
    @AppStorage("savedPaths") private var savedPaths: String = "[\"/Applications\", \"/System/Applications\", \"/System/Library/CoreServices/Applications\", ]"
    static var hideWindow = false
    
    static var keepMiddle: Bool {
        if let value = UserDefaults.standard.value(forKey: "keepMiddle") as? Bool {
            return value
        } else {
            return true
        }
    }

    let showControl = ShowControl()

    init() {
        handleCommandLineArguments()
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: "tech.orbitalfetch.lancelot")
        let currentApp = NSRunningApplication.current
        for app in runningApps {
            if app != currentApp {
                app.forceTerminate()
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(savedPaths: $savedPaths, showPaths: $showPaths)
                .environmentObject(keybindManager)
        }
        .windowStyle(.hiddenTitleBar)
        Settings {
            PreferencePaneView(savedPaths: $savedPaths, showPaths: $showPaths)
                .environmentObject(keybindManager)
                .onAppear {
                    if let settingsWindow = NSApplication.shared.windows.last {
                        settingsWindow.level = .modalPanel
                    }
                }
        }
        
        /// Menu Bar
        MenuBarExtra("Lancelot", systemImage: "figure.fencing") {
            Button("Show Lancelot") {
                showControl.unhide()
            }
            Divider()
            SettingsLink {
                Text("Settings")
            }
            .keyboardShortcut(",")
            Divider()
            Button("Quit") {
                appDelegate.internalTerminate()
            }
        }
    }
    private func handleCommandLineArguments() {
        let arguments = CommandLine.arguments
        if arguments.count > 1 {
            for arg in arguments[1...] {
                switch arg {
                case "--startupLaunch":
                    lancelotApp.hideWindow = true
                    break
                case "--version":
                    print("Lancelot v1.1")
                    break
                case "-NSDocumentRevisionsDebugMode":
                    print("Note: The app is being launched as debug.")
                    break
                default:
                    continue
                }
            }
        }
    }
}

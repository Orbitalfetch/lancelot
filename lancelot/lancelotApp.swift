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
    @AppStorage("savedPaths") private var savedPaths: String = "[\"/Applications\"]"

    let showControl = ShowControl()

    init() {
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
            ContentView(savedPaths: $savedPaths)
                .environmentObject(keybindManager)
        }
        .windowStyle(.hiddenTitleBar)
        Settings {
            PreferencePaneView(savedPaths: $savedPaths)
                .environmentObject(keybindManager)
        }
        
        /// Menu Bar
        MenuBarExtra("Lancelot", systemImage: "figure.fencing") {
            Button("Show Lancelot") {
                showControl.unhide()
            }
            .keyboardShortcut("D")
            Divider()
            Button("Settings") {
                print("show settings")
            }
            .keyboardShortcut(",")
            Divider()
            Button("Quit") {
                appDelegate.internalTerminate()
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var isProgrammaticTermination = false
    let showControl = ShowControl()
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.delegate = self
        }
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        showControl.hide()
        return false
    }
    func windowDidResignKey(_ notification: Notification) {
        showControl.hide()
    }
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if isProgrammaticTermination {
            return .terminateNow
        }
        // nuhuh
        return .terminateCancel
    }
    
    func internalTerminate() {
        isProgrammaticTermination = true
        NSApplication.shared.terminate(nil)
    }
}

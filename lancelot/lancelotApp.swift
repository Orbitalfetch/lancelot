//
//  lancelotApp.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI

@main
struct lancelotApp: App {
    @StateObject var keybindManager = KeybindManager()
    let showControl = ShowControl()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(keybindManager)
                .onEscape {
                    showControl.hide()
                }
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.titleVisibility = .hidden
                        window.titlebarAppearsTransparent = true
                        window.standardWindowButton(.closeButton)?.isHidden = true
                        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                        window.standardWindowButton(.zoomButton)?.isHidden = true
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        Settings {
            PreferencePaneView()
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
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

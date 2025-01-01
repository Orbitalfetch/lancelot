//
//  lancelotApp.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI

@main
struct lancelotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onEscape {
                    NSApplication.shared.hide(nil)
                }
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.titleVisibility = .hidden
                        window.titlebarAppearsTransparent = true
                        window.styleMask.remove(.closable)
                        window.styleMask.remove(.resizable)
                        window.styleMask.remove(.miniaturizable)
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        Settings {
            PreferencePaneView()
        }
        
        /// Menu Bar
        MenuBarExtra("Lancelot", systemImage: "figure.fencing") {
            Button("Show Lancelot") {
                NSApplication.shared.unhide(nil)
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

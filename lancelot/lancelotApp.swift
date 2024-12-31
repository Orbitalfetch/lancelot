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
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.titleVisibility = .hidden
                        window.titlebarAppearsTransparent = true
                        window.styleMask.remove(.titled)
                        window.styleMask.remove(.closable)
                        window.styleMask.remove(.resizable)
                        window.styleMask.remove(.miniaturizable)
                    }
                }
        }
    }
}

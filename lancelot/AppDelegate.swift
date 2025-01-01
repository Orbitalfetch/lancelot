//
//  AppDelegate.swift
//  lancelot
//
//  Created by Constantin Clerc on 02/01/2025.
//

import SwiftUI

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

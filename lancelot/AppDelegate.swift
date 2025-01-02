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
            window.level = .floating
        }
        restoreBookmarkedFolders()
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
    
    func restoreBookmarkedFolders() {
        let defaults = UserDefaults.standard
        let bookmarkKeys = defaults.dictionaryRepresentation().keys.filter { $0.starts(with: "FolderBookmark-") }
        
        for key in bookmarkKeys {
            if let bookmarkData = defaults.data(forKey: key) {
                do {
                    var isStale = false
                    let url = try URL(
                        resolvingBookmarkData: bookmarkData,
                        options: .withSecurityScope,
                        relativeTo: nil,
                        bookmarkDataIsStale: &isStale
                    )
                    
                    if isStale {
                        let newBookmarkData = try url.bookmarkData(
                            options: .withSecurityScope,
                            includingResourceValuesForKeys: nil,
                            relativeTo: nil
                        )
                        defaults.set(newBookmarkData, forKey: key)
                    }
                    
                    _ = url.startAccessingSecurityScopedResource()
                } catch {
                    print("failed to resolve bookmark:", error)
                }
            }
        }
    }
}

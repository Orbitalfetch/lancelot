//
//  ShowControl.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import AppKit

class ShowControl {
    func hide() {
        NSApplication.shared.hide(nil)
    }
    func unhide() {
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = [.moveToActiveSpace]
        }
        NSApplication.shared.unhide(nil)
        firstPlan()
    }
    func firstPlan() {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApplication.shared.windows.first {
            window.makeKeyAndOrderFront(nil)
            window.level = .floating
        }
    }
}

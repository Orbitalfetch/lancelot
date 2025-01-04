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
            window.styleMask.remove(.resizable)
            
            if lancelotApp.keepMiddle {
                if let screenFrame = window.screen?.frame {
                    let windowSize = window.frame.size
                    
                    let centerX = screenFrame.midX - (windowSize.width / 2)
                    let centerY = screenFrame.midY - (windowSize.height / 2)
                    
                    let windowPosition = NSPoint(x: centerX, y: centerY)
                    
                    window.setFrameOrigin(windowPosition)
                }
            }
        }
    }
}

//
//  IconLoader.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import AppKit

class Iconloader {
    func getIconNew(_ appPath: String) -> NSImage {
        let iconSize = NSSize(width: 32, height: 32)
        let nsImage = NSWorkspace.shared.icon(forFile: appPath)
        nsImage.size = iconSize
        return nsImage
    }
}

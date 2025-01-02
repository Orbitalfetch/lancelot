//
//  AppModel.swift
//  lancelot
//
//  Created by Constantin Clerc on 31/12/2024.
//

import AppKit.NSImage

struct AppModel: Identifiable {
    var id = UUID()
    let name: String
    let path: String
    let icon: NSImage
}

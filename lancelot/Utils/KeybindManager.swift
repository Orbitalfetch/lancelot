//
//  KeybindManager.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import Foundation
import HotKey
import AppKit

class KeybindManager: ObservableObject {
    @Published var currentKey: Key = .d
    @Published var currentModifiers: NSEvent.ModifierFlags = [.command]
    @Published var isRecordingKeybind = false
    
    private let defaults = UserDefaults.standard
    private let keyKey = "userHotkey.keyCode"
    private let modifiersKey = "userHotkey.modifiers"
    
    init() {
        if let savedKeyCode = defaults.object(forKey: keyKey) as? UInt32,
           let savedModifiers = defaults.object(forKey: modifiersKey) as? UInt {
            currentKey = Key(carbonKeyCode: savedKeyCode) ?? .d
            currentModifiers = NSEvent.ModifierFlags(rawValue: savedModifiers)
        }
    }
    
    func saveKeybind(key: Key, modifiers: NSEvent.ModifierFlags) {
        currentKey = key
        currentModifiers = modifiers
        defaults.set(key.carbonKeyCode, forKey: keyKey)
        defaults.set(modifiers.rawValue, forKey: modifiersKey)
    }
}

extension NSEvent.ModifierFlags {
    var hotKeyModifiers: NSEvent.ModifierFlags {
        var modifiers: NSEvent.ModifierFlags = []
        if contains(.command) { modifiers.insert(.command) }
        if contains(.option) { modifiers.insert(.option) }
        if contains(.control) { modifiers.insert(.control) }
        if contains(.shift) { modifiers.insert(.shift) }
        return modifiers
    }
}

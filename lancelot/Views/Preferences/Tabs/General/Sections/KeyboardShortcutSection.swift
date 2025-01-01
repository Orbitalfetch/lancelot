//
//  KeyboardShortcutSection.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct KeyboardShortcutSection: View {
    @EnvironmentObject var keybindManager: KeybindManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Keyboard Shortcuts")
                .font(.headline)
            
            HStack {
                Text("Toggle app:")
                Spacer()
                Text(getKeybindString())
                    .foregroundColor(.secondary)
                KeyRecorderView(isRecording: $keybindManager.isRecordingKeybind) { key, modifiers in
                    keybindManager.saveKeybind(key: key, modifiers: modifiers)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func getKeybindString() -> String {
        let modifierString = keybindManager.currentModifiers.description
        let keyString = keybindManager.currentKey.description
        return "\(modifierString) + \(keyString)"
    }
}

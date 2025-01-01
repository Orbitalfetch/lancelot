//
//  KeyRecorderView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
import HotKey

struct KeyRecorderView: View {
    @Binding var isRecording: Bool
    let onKeybindSet: (Key, NSEvent.ModifierFlags) -> Void
    
    var body: some View {
        Button(action: {
            isRecording.toggle()
        }) {
            Text(isRecording ? "Press any key..." : "Record Keybind")
        }
        .buttonStyle(.borderedProminent)
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
                if isRecording {
                    if let key = Key(carbonKeyCode: UInt32(event.keyCode)) {
                        onKeybindSet(key, event.modifierFlags)
                        isRecording = false
                    }
                    return nil
                }
                return event
            }
        }
    }
}

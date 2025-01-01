//
//  KeyEventModifier.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct KeyEventModifier: ViewModifier {
    let onEscape: () -> Void
    
    func body(content: Content) -> some View {
        content.onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 53 {
                    onEscape()
                }
                return event
            }
        }
    }
}

extension View {
    func onEscape(perform action: @escaping () -> Void) -> some View {
        modifier(KeyEventModifier(onEscape: action))
    }
}

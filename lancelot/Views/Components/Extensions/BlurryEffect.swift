//
//  BlurryEffect.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct BlurryEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        effectView.blendingMode = .behindWindow
        effectView.material = .sidebar
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

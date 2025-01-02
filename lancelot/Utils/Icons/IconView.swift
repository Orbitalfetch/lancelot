//
//  IconView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct IconView: View {
    let icon: NSImage
    var body: some View {
        Image(nsImage: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
    }
}

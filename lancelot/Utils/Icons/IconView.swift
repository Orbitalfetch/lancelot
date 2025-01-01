//
//  IconView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct IconView: View {
    let imgPath: String
    var body: some View {
        if let img = NSImage(contentsOf: URL(fileURLWithPath: imgPath)) {
            Image(nsImage: getSpecificResolution(from: img, size: NSSize(width: 32, height: 32)))
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        } else {
            Image(systemName: "app.dashed")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
    }
    private func getSpecificResolution(from image: NSImage, size: NSSize) -> NSImage {
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        
        if let bestReprers = image.bestRepresentation(for: NSRect(origin: .zero, size: size), context: nil, hints: nil) {
            bestReprers.draw(in: NSRect(origin: .zero, size: size))
        }
        
        newImage.unlockFocus()
        return newImage
    }
}

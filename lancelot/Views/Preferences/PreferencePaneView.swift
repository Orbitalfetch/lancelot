//
//  PreferencePaneView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
struct PreferencePaneView: View {
    @Binding var savedPaths: String
    var body: some View {
        TabView {
            GeneralSettingsView(savedPaths: $savedPaths)
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            
            PathSettingsView(savedPaths: $savedPaths)
                .tabItem {
                    Label("Paths", systemImage: "folder.badge.gearshape")
                }
        }
        .frame(width: 500, height: 280)
    }
}

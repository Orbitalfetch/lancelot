//
//  PreferencePaneView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI
 
struct PreferencePaneView: View {
    var body: some View {
        TabView {
            Group{
                Text("some settings")
            }
            .tabItem {
                Label("General", systemImage: "gearshape")
            }
        }
        .frame(width: 500, height: 280)
    }
}

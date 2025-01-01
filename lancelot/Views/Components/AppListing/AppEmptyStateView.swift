//
//  AppEmptyStateView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct AppEmptyStateView: View {
    var body: some View {
        Spacer()
        Image(systemName: "app.dashed")
            .foregroundStyle(.secondary)
            .font(.system(size: 48))
            .padding(.bottom, 8)
        Text("No apps found.")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
        Spacer()
    }
}

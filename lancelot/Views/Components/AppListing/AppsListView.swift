//
//  AppsListView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct AppsListView: View {
    @Binding var filteredApps: [AppModel]
    let iconLoader: Iconloader
    @Binding var selectedIndex: Int
    let onAppSelected: (AppModel) -> Void
    
    var body: some View {
        List(filteredApps.indices, id: \.self) { index in
            HStack {
                IconView(imgPath: filteredApps[index].iconPath)
                Text(filteredApps[index].name)
                Text(filteredApps[index].path)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.vertical, 4)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 6)
                    .fill(index == selectedIndex ? Color.accentColor.opacity(0.3) : Color.clear)
                    .padding(.horizontal, 4)
            )
            .onTapGesture {
                selectedIndex = index
                onAppSelected(filteredApps[index])
            }
        }
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

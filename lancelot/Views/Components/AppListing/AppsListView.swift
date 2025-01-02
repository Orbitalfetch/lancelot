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
        ScrollViewReader { proxy in
            List(filteredApps.indices, id: \.self) { index in
                HStack {
                    IconView(icon: filteredApps[index].icon)
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
                .id(index)
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.never)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .onChange(of: selectedIndex) {
                withAnimation {
                    proxy.scrollTo(selectedIndex, anchor: .center)
                }
            }
        }
    }
}

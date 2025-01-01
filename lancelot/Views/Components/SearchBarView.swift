//
//  SearchBarView.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState.Binding var isSearchFieldFocused: Bool
    let onFilter: (String) -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 20))
                .padding(.leading, 12)
            
            TextField("Search for apps...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 16))
                .padding(.vertical, 12)
                .focused($isSearchFieldFocused)
                .onChange(of: searchText) {
                    onFilter(searchText)
                }
                .onSubmit {
                    onSubmit()
                }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separatorColor))
        }
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

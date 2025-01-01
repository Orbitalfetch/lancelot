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
        TextField("Search for apps...", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .focused($isSearchFieldFocused)
            .onChange(of: searchText) {
                onFilter(searchText)
            }
            .onSubmit {
                onSubmit()
            }
    }
}

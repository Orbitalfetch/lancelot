//
//  ShowPathsInList.swift
//  lancelot
//
//  Created by Theo Marcos on 02.01.2025.
//

import SwiftUI

struct ShowPathsInList: View {
    @Binding var showPaths: Bool

    var body: some View {
        Toggle("Show paths next to apps", isOn: $showPaths)
    }
}

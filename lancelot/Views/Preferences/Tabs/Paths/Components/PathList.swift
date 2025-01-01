//
//  PathList.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct PathList: View {
    @Binding var paths: [String]
    @Binding var editingIndex: Int?
    let onSave: () -> Void
    
    var body: some View {
        List {
            ForEach(paths.indices, id: \.self) { index in
                if editingIndex == index {
                    HStack {
                        TextField("Edit Path", text: Binding(
                            get: { paths[index] },
                            set: { paths[index] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Save") {
                            onSave()
                            editingIndex = nil
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                } else {
                    HStack {
                        Text(paths[index])
                        Spacer()
                        Button("Edit") {
                            editingIndex = index
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button("Delete") {
                            paths.remove(at: index)
                            onSave()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

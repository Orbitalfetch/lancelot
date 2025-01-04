//
//  KeepInMiddle.swift
//  lancelot
//
//  Created by Theo Marcos on 04.01.2025.
//

import SwiftUI

struct KeepInMiddle: View {
    @State var keepMiddle: Bool = UserDefaults.standard.bool(forKey: "keepMiddle") // Retrieve initial value
    
    var body: some View {
        Toggle("Keep in the middle", isOn: $keepMiddle)
            .onChange(of: keepMiddle) {
                // Update UserDefaults when the toggle changes
                UserDefaults.standard.set(keepMiddle, forKey: "keepMiddle")
            }
    }
}

//
//  KeepInMiddle.swift
//  lancelot
//
//  Created by Theo Marcos on 04.01.2025.
//

import SwiftUI

struct KeepInMiddle: View {
    @State var keepMiddle: Bool = lancelotApp.keepMiddle
    var body: some View {
        Toggle("Keep in the middle", isOn: $keepMiddle)
            .onChange(of: keepMiddle) {
                lancelotApp.keepMiddle = !lancelotApp.keepMiddle
                print("lApp: \(lancelotApp.keepMiddle), toggle: \(keepMiddle)")
            }
    }
}

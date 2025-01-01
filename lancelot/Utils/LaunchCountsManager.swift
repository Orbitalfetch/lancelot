//
//  LaunchCountsManager.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

class LaunchCountsManager: ObservableObject {
    @AppStorage("appLaunchCounts") private var appLaunchCountsJSON: String = "{}"
    @Published var appLaunchCounts: [String: Int] = [:]
    
    init() {
        loadLaunchCounts()
    }
    
    func loadLaunchCounts() {
        if let data = appLaunchCountsJSON.data(using: .utf8),
           let decodedCounts = try? JSONDecoder().decode([String: Int].self, from: data) {
            appLaunchCounts = decodedCounts
        } else {
            appLaunchCounts = [:]
        }
    }
    
    func saveLaunchCounts() {
        if let data = try? JSONEncoder().encode(appLaunchCounts),
           let jsonString = String(data: data, encoding: .utf8) {
            appLaunchCountsJSON = jsonString
        }
    }
    
    func incrementLaunchCount(for appName: String) {
        appLaunchCounts[appName, default: 0] += 1
        saveLaunchCounts()
    }
}

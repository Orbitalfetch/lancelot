//
//  LaunchAtLoginToggle.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import SwiftUI

struct LaunchAtLoginToggle: View {
    @State private var isEnabled: Bool = false
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    var body: some View {
        Toggle("Launch at Login", isOn: $isEnabled)
            .onChange(of: isEnabled) {
                toggleLaunchAtLogin(enabled: isEnabled)
            }
            .onAppear {
                let fileManager = FileManager()
                let libPath = fileManager.homeDirectoryForCurrentUser.path + "/Library/LaunchAgents/"
                let destinationPath = libPath + "tech.orbitalfetch.lancelot.startup.plist"
                if fileManager.fileExists(atPath: destinationPath) {
                    isEnabled = true
                }
                else {
                    isEnabled = false
                }
            }
    }
    
    private func toggleLaunchAtLogin(enabled: Bool) {
        let fileManager = FileManager.default
        guard let launchAgentPath = Bundle.main.path(forResource: "tech.orbitalfetch.lancelot.startup", ofType: "plist") else {
            print("LaunchAgent plist not found in bundle")
            return
        }
        
        let libPath = fileManager.homeDirectoryForCurrentUser.path + "/Library/LaunchAgents/"
        let destinationPath = libPath + "tech.orbitalfetch.lancelot.startup.plist"
        if isEnabled {
            do {
                if !fileManager.fileExists(atPath: libPath) {
                    try fileManager.createDirectory(atPath: libPath, withIntermediateDirectories: true, attributes: nil)
                }
                
                if fileManager.fileExists(atPath: destinationPath) {
                    try fileManager.removeItem(atPath: destinationPath)
                }
                
                guard let plistData = try? Data(contentsOf: URL(fileURLWithPath: launchAgentPath)),
                      var plistContent = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any],
                      var programArgs = plistContent["ProgramArguments"] as? [String] else {
                    print("Failed to read plist content")
                    return
                }
                
                if let execPath = Bundle.main.executablePath {
                    programArgs[0] = execPath
                    plistContent["ProgramArguments"] = programArgs
                    
                    let modifiedData = try PropertyListSerialization.data(fromPropertyList: plistContent, format: .xml, options: 0)
                    try modifiedData.write(to: URL(fileURLWithPath: destinationPath))
                }
            } catch {
                print(error)
            }
        }
        else {
            do {
                if fileManager.fileExists(atPath: destinationPath) {
                    try fileManager.removeItem(atPath: destinationPath)
                }
            }
            catch {
                print(error)
            }
        }
    }
}

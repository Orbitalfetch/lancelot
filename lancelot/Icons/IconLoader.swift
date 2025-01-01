//
//  IconLoader.swift
//  lancelot
//
//  Created by Constantin Clerc on 01/01/2025.
//

import Foundation

class Iconloader {
    func getIcnsPath(_ appPath: String) -> String {
        let plistFilePath = appPath + "/Contents/Info.plist"
        if let plistAsHashmap = plistToHashmap(plistFilePath) {
            let iconPath = getIconsFromPlist(plistAsHashmap, appPath: appPath) ?? ""
            return iconPath

        }
        else {
            print("The Info.plist file could not be decoded.")
            return ""
        }
    }
    
    private func plistToHashmap(_ plistPath: String) -> [String: Any]? {
        let url = URL(fileURLWithPath: plistPath)
        do {
            let data = try Data(contentsOf: url)
            
            if let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                return plist
            } else {
                print("Failed to cast plist into hashmap")
            }
        } catch {
            print("Error loading plist: \(error)")
        }
        return nil
    }
    
    private func getIconsFromPlist(_ plistAsHashmap: [String: Any], appPath: String) -> String? {
        if let iconFileName = plistAsHashmap["CFBundleIconFile"] as? String {
            let iconPath = (appPath as NSString).appendingPathComponent(
                "Contents/Resources/\(iconFileName.hasSuffix(".icns") ? iconFileName : "\(iconFileName).icns")"
            )
            if FileManager.default.fileExists(atPath: iconPath) {
                return iconPath
            }
        }
        // no icon path was found..
        return nil
    }
}

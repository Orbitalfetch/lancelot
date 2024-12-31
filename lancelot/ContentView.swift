//
//  ContentView.swift
//  lancelot
//
//  Created by Theo Marcos on 31.12.2024.
//

import SwiftUI
import AppKit

struct BlurryEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.state = .active
        effectView.blendingMode = .behindWindow
        effectView.material = .sidebar  // You can adjust the material
        return effectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}

struct ContentView: View {
    @State private var searchText = ""
    @State private var appList: [String] = []

    var body: some View {
        ZStack {
            BlurryEffect()
                .ignoresSafeArea()

            VStack {
                TextField("Search for apps...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText, perform: { newValue in
                        filterApps()
                    })

                if appList.isEmpty {
                    Text("No apps found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(appList, id: \.self) { app in
                        Text(app)
                    }
                    .scrollContentBackground(.hidden) // Ensures List background is transparent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .onAppear(perform: loadApplications)
        .frame(minWidth: 400, minHeight: 400)
    }

    // Load all applications
    private func loadApplications() {
        let applicationsPath = "/Applications"
        let fileManager = FileManager.default

        do {
            let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
            // Filter to include only .app bundles
            appList = contents.filter { $0.hasSuffix(".app") }
        } catch {
            print("Error loading applications: \(error)")
        }
    }

    // Filter applications based on search text
    private func filterApps() {
        if searchText.isEmpty {
            loadApplications()
        } else {
            let applicationsPath = "/Applications"
            let fileManager = FileManager.default

            do {
                let contents = try fileManager.contentsOfDirectory(atPath: applicationsPath)
                // Filter to include only .app bundles that match the search text
                appList = contents.filter { $0.hasSuffix(".app") && $0.lowercased().contains(searchText.lowercased()) }
            } catch {
                print("Error filtering applications: \(error)")
            }
        }
    }
}

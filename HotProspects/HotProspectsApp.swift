//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//
import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeTabView()
        }
        .modelContainer(for: Prospect.self)
    }
}

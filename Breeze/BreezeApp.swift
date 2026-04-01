//
//  BreezeApp.swift
//  Breeze
//
//  Created by nestcc on 30/3/2026.
//

import SwiftUI

@main
struct BreezeApp: App {
    var body: some Scene {
        MenuBarExtra("Breeze", systemImage: "doc.badge.plus") {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.menu)
    }
}

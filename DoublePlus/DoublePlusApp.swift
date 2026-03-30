//
//  DoublePlusApp.swift
//  DoublePlus
//
//  Created by nestcc on 30/3/2026.
//

import SwiftUI

@main
struct DoublePlusApp: App {
    var body: some Scene {
        MenuBarExtra("DoublePlus", systemImage: "doc.badge.plus") {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.menu)
    }
}

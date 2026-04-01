//
//  MenuBarContentView.swift
//  Breeze
//
//  Created by nestcc on 30/3/2026.
//

import AppKit
import FinderSync
import SwiftUI

struct MenuBarContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Breeze")
                .font(.headline)
            Text("Right-click empty space or a selection in a Finder window, then choose the Breeze submenu to create a file or folder.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if !FIFinderSyncController.isExtensionEnabled {
                Text("Breeze won’t appear under File Providers—that’s a different extension type. Use the button below, search Settings for Breeze, or run in Terminal (after launching Breeze once): pluginkit -e use -p com.apple.FinderSync -i Ncc.Breeze.FinderSync")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Divider()
            Button("Manage Finder Extensions…") {
                FIFinderSyncController.showExtensionManagementInterface()
            }
            Button("Quit Breeze") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .padding(12)
        .frame(minWidth: 280)
    }
}

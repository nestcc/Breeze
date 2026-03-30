//
//  MenuBarContentView.swift
//  DoublePlus
//
//  Created by nestcc on 30/3/2026.
//

import AppKit
import FinderSync
import SwiftUI

struct MenuBarContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("DoublePlus")
                .font(.headline)
            Text("在 Finder 窗口空白处或选中项上右键，选择「DoublePlus」子菜单即可新建文件或文件夹。")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if !FIFinderSyncController.isExtensionEnabled {
                Text("请先在「系统设置 → 隐私与安全性 → 扩展 → 添加的扩展」中启用 DoublePlus 的 Finder 扩展。")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Divider()
            Button("管理 Finder 扩展…") {
                FIFinderSyncController.showExtensionManagementInterface()
            }
            Button("退出 DoublePlus") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
        .padding(12)
        .frame(minWidth: 280)
    }
}

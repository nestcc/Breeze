import Foundation
import os

public enum FileCreationError: Error, LocalizedError {
    case noDirectoryURL
    case couldNotCreate

    public var errorDescription: String? {
        switch self {
        case .noDirectoryURL:
            return "Could not determine the target folder."
        case .couldNotCreate:
            return "Could not create the file or folder."
        }
    }
}

public enum FileCreationService {
    private static let logger = Logger(subsystem: "Ncc.Breeze", category: "FileCreation")

    public static func debugLog(_ message: String) {
        logger.log("\(message, privacy: .public)")
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: SharedAppGroup.identifier) else {
            return
        }
        let logURL = groupURL.appendingPathComponent("breeze-debug.log", isDirectory: false)
        let line = "\(Date()): \(message)\n"
        let data = Data(line.utf8)
        if FileManager.default.fileExists(atPath: logURL.path) {
            if let handle = try? FileHandle(forWritingTo: logURL) {
                defer { try? handle.close() }
                try? handle.seekToEnd()
                try? handle.write(contentsOf: data)
            }
        } else {
            try? data.write(to: logURL, options: .atomic)
        }
    }

    /// Executes work while holding security-scoped access (when available) for sandboxed extensions.
    public static func withWriteAccess<T>(to directory: URL, _ work: (URL) throws -> T) throws -> T {
        let hasScopedAccess = directory.startAccessingSecurityScopedResource()
        defer {
            if hasScopedAccess {
                directory.stopAccessingSecurityScopedResource()
            }
        }
        debugLog("withWriteAccess path=\(directory.path) scoped=\(hasScopedAccess)")
        return try work(directory)
    }

    /// Resolves the directory for “new file/folder” from Finder context.
    public static func directoryURL(for context: FinderActionContext) -> URL? {
        switch context.menuKind {
        case .contextualMenuForContainer, .contextualMenuForSidebar:
            return context.targetedURL
        case .contextualMenuForItems:
            guard let url = context.targetedURL ?? context.selectedItemURLs.first else { return nil }
            // For item-context menus, create next to the selected item (same visible folder),
            // not *inside* a selected folder.
            return url.deletingLastPathComponent()
        case .toolbarItemMenu:
            return context.targetedURL
        }
    }

    /// Picks a non-conflicting name like `base.ext`, `base 2.ext`, …
    public static func uniqueFileURL(in directory: URL, baseName: String, fileExtension: String) -> URL {
        let ext = fileExtension.trimmingCharacters(in: CharacterSet(charactersIn: "."))
        let fm = FileManager.default
        func url(for stem: String) -> URL {
            if ext.isEmpty {
                return directory.appendingPathComponent(stem, isDirectory: false)
            }
            return directory.appendingPathComponent(stem).appendingPathExtension(ext)
        }
        var candidate = url(for: baseName)
        var index = 2
        while fm.fileExists(atPath: candidate.path) {
            candidate = url(for: "\(baseName) \(index)")
            index += 1
        }
        return candidate
    }

    /// Picks a non-conflicting folder name.
    public static func uniqueFolderURL(in directory: URL, baseName: String) -> URL {
        let fm = FileManager.default
        var candidate = directory.appendingPathComponent(baseName, isDirectory: true)
        var index = 2
        while fm.fileExists(atPath: candidate.path) {
            candidate = directory.appendingPathComponent("\(baseName) \(index)", isDirectory: true)
            index += 1
        }
        return candidate
    }

    public static func createFile(at url: URL, contents: Data = Data()) throws {
        try contents.write(to: url, options: .withoutOverwriting)
    }

    public static func createFolder(at url: URL) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
    }
}

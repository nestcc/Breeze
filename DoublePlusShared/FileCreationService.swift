import Foundation

public enum FileCreationError: Error, LocalizedError {
    case noDirectoryURL
    case couldNotCreate

    public var errorDescription: String? {
        switch self {
        case .noDirectoryURL:
            return "无法确定目标文件夹。"
        case .couldNotCreate:
            return "无法创建文件或文件夹。"
        }
    }
}

public enum FileCreationService {
    /// Resolves the directory for “new file/folder” from Finder context.
    public static func directoryURL(for context: FinderActionContext) -> URL? {
        switch context.menuKind {
        case .contextualMenuForContainer, .contextualMenuForSidebar:
            return context.targetedURL
        case .contextualMenuForItems:
            guard let url = context.targetedURL ?? context.selectedItemURLs.first else { return nil }
            var isDir: ObjCBool = false
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) else { return nil }
            if isDir.boolValue { return url }
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

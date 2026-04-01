import Foundation

public enum BuiltInActionID {
    public static let newTextFile = "newTextFile"
    public static let newJSONFile = "newJSONFile"
    public static let newMarkdownFile = "newMarkdownFile"
    public static let newFolder = "newFolder"
}

public struct NewTextFileAction: FinderContextAction {
    public let id = BuiltInActionID.newTextFile
    public let title = "New Text File"

    public init() {}

    public func supports(menuKind: FinderMenuKind) -> Bool {
        switch menuKind {
        case .contextualMenuForContainer, .contextualMenuForItems, .contextualMenuForSidebar:
            return true
        case .toolbarItemMenu:
            return false
        }
    }

    public func validate(context: FinderActionContext) -> Bool {
        FileCreationService.directoryURL(for: context) != nil
    }

    public func perform(context: FinderActionContext) throws {
        guard let dir = FileCreationService.directoryURL(for: context) else {
            throw FileCreationError.noDirectoryURL
        }
        try FileCreationService.withWriteAccess(to: dir) { writableDir in
            let url = FileCreationService.uniqueFileURL(in: writableDir, baseName: "Untitled", fileExtension: "txt")
            try FileCreationService.createFile(at: url, contents: Data())
        }
    }
}

public struct NewJSONFileAction: FinderContextAction {
    public let id = BuiltInActionID.newJSONFile
    public let title = "New JSON File"

    public init() {}

    public func supports(menuKind: FinderMenuKind) -> Bool {
        switch menuKind {
        case .contextualMenuForContainer, .contextualMenuForItems, .contextualMenuForSidebar:
            return true
        case .toolbarItemMenu:
            return false
        }
    }

    public func validate(context: FinderActionContext) -> Bool {
        FileCreationService.directoryURL(for: context) != nil
    }

    public func perform(context: FinderActionContext) throws {
        guard let dir = FileCreationService.directoryURL(for: context) else {
            throw FileCreationError.noDirectoryURL
        }
        try FileCreationService.withWriteAccess(to: dir) { writableDir in
            let url = FileCreationService.uniqueFileURL(in: writableDir, baseName: "Untitled", fileExtension: "json")
            try FileCreationService.createFile(at: url, contents: Data())
        }
    }
}

public struct NewMarkdownFileAction: FinderContextAction {
    public let id = BuiltInActionID.newMarkdownFile
    public let title = "New Markdown File"

    public init() {}

    public func supports(menuKind: FinderMenuKind) -> Bool {
        switch menuKind {
        case .contextualMenuForContainer, .contextualMenuForItems, .contextualMenuForSidebar:
            return true
        case .toolbarItemMenu:
            return false
        }
    }

    public func validate(context: FinderActionContext) -> Bool {
        FileCreationService.directoryURL(for: context) != nil
    }

    public func perform(context: FinderActionContext) throws {
        guard let dir = FileCreationService.directoryURL(for: context) else {
            throw FileCreationError.noDirectoryURL
        }
        try FileCreationService.withWriteAccess(to: dir) { writableDir in
            let url = FileCreationService.uniqueFileURL(in: writableDir, baseName: "Untitled", fileExtension: "md")
            try FileCreationService.createFile(at: url, contents: Data())
        }
    }
}

public struct NewFolderAction: FinderContextAction {
    public let id = BuiltInActionID.newFolder
    public let title = "New Folder"

    public init() {}

    public func supports(menuKind: FinderMenuKind) -> Bool {
        switch menuKind {
        case .contextualMenuForContainer, .contextualMenuForItems, .contextualMenuForSidebar:
            return true
        case .toolbarItemMenu:
            return false
        }
    }

    public func validate(context: FinderActionContext) -> Bool {
        FileCreationService.directoryURL(for: context) != nil
    }

    public func perform(context: FinderActionContext) throws {
        guard let dir = FileCreationService.directoryURL(for: context) else {
            throw FileCreationError.noDirectoryURL
        }
        try FileCreationService.withWriteAccess(to: dir) { writableDir in
            let url = FileCreationService.uniqueFolderURL(in: writableDir, baseName: "New Folder")
            try FileCreationService.createFolder(at: url)
        }
    }
}

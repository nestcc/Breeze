import Foundation

public enum BuiltInActionID {
    public static let newTextFile = "newTextFile"
    public static let newMarkdownFile = "newMarkdownFile"
    public static let newFolder = "newFolder"
}

public struct NewTextFileAction: FinderContextAction {
    public let id = BuiltInActionID.newTextFile
    public let title = "新建文本文件"

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
        let url = FileCreationService.uniqueFileURL(in: dir, baseName: "未命名", fileExtension: "txt")
        try FileCreationService.createFile(at: url, contents: Data())
    }
}

public struct NewMarkdownFileAction: FinderContextAction {
    public let id = BuiltInActionID.newMarkdownFile
    public let title = "新建 Markdown 文件"

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
        let url = FileCreationService.uniqueFileURL(in: dir, baseName: "未命名", fileExtension: "md")
        try FileCreationService.createFile(at: url, contents: Data())
    }
}

public struct NewFolderAction: FinderContextAction {
    public let id = BuiltInActionID.newFolder
    public let title = "新建文件夹"

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
        let url = FileCreationService.uniqueFolderURL(in: dir, baseName: "新建文件夹")
        try FileCreationService.createFolder(at: url)
    }
}

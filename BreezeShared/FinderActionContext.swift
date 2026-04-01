import Foundation

/// Context passed to a Finder context action (container vs selection, URLs).
public struct FinderActionContext: Sendable {
    public let menuKind: FinderMenuKind
    /// Primary URL from Finder (folder or item), per `FIFinderSyncController.targetedURL`.
    public let targetedURL: URL?
    /// Selected item URLs when the menu applies to a selection.
    public let selectedItemURLs: [URL]

    public init(menuKind: FinderMenuKind, targetedURL: URL?, selectedItemURLs: [URL]) {
        self.menuKind = menuKind
        self.targetedURL = targetedURL
        self.selectedItemURLs = selectedItemURLs
    }
}

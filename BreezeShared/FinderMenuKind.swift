import Foundation

/// Mirrors Finder `FIMenuKind` without linking `FinderSync` in the host app.
public enum FinderMenuKind: Sendable {
    case contextualMenuForContainer
    case contextualMenuForItems
    case contextualMenuForSidebar
    case toolbarItemMenu
}

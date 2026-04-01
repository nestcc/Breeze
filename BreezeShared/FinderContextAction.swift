import Foundation

/// Pluggable Finder action (e.g. new file, future “share”).
public protocol FinderContextAction: Sendable {
    var id: String { get }
    var title: String { get }

    func supports(menuKind: FinderMenuKind) -> Bool
    func validate(context: FinderActionContext) -> Bool
    func perform(context: FinderActionContext) throws
}

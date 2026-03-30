import Foundation

/// Central registry for Finder actions. Add new types here (e.g. share) for extension menus.
public final class ActionRegistry: @unchecked Sendable {
    public static let shared = ActionRegistry()

    private let lock = NSLock()
    private var actions: [String: any FinderContextAction] = [:]
    private var orderedIDs: [String] = []

    private init() {
        registerBuiltIn()
    }

    public func register(_ action: any FinderContextAction) {
        lock.lock()
        defer { lock.unlock() }
        actions[action.id] = action
        if !orderedIDs.contains(action.id) {
            orderedIDs.append(action.id)
        }
    }

    public func action(id: String) -> (any FinderContextAction)? {
        lock.lock()
        defer { lock.unlock() }
        return actions[id]
    }

    /// Actions applicable to this menu kind, in registration order.
    public func actions(for menuKind: FinderMenuKind) -> [any FinderContextAction] {
        lock.lock()
        defer { lock.unlock() }
        return orderedIDs.compactMap { actions[$0] }.filter { $0.supports(menuKind: menuKind) }
    }

    private func registerBuiltIn() {
        register(NewTextFileAction())
        register(NewMarkdownFileAction())
        register(NewFolderAction())
    }
}

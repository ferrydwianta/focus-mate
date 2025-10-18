import Foundation
import OSLog

enum LogCategory: String {
    case app = "App"
    case storage = "Storage"
    case notifications = "Notifications"
    case permissions = "Permissions"
}

struct AppLogger {
    static let subsystem = "com.yourcompany.FocusMate"

    static func logger(_ category: LogCategory) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    static func debug(_ message: String, category: LogCategory = .app) {
        logger(category).debug("\(message)")
    }

    static func info(_ message: String, category: LogCategory = .app) {
        logger(category).info("\(message)")
    }

    static func error(_ message: String, category: LogCategory = .app) {
        logger(category).error("\(message)")
    }
}

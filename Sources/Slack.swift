import Foundation

// MARK: - Slack Service

enum SlackService {
    static func open(team: String, channel: String) throws {
        try Fork.exec("/usr/bin/open", args: ["slack://channel?team=\(team)&id=\(channel)"])
    }
}

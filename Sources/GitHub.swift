import Foundation

enum Errors: String, Error, CustomStringConvertible {
    case terminationError
    case dataConversionError

    var description: String {
        self.rawValue
    }
}

// MARK: - Wrapper for Process run

enum Fork {
    @discardableResult
    static func exec(_ bin: String, args: [String]) throws -> String {
        let stdout = Pipe()
        let process = Process()
        process.launchPath = bin
        process.arguments = args
        process.standardOutput = stdout

        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw Errors.terminationError
        }

        let data = stdout.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return output
    }
}

// MARK: - GitHub PR Models

struct PRModel: Decodable, CustomStringConvertible {
    let number: Int
    let title: String
    let url: String
    let files: [PRFileModel]

    var description: String {
        "PR#\(self.number): \(self.title)"
    }
}

struct PRFileModel: Decodable, CustomStringConvertible {
    let path: String
    let additions: Int
    let deletions: Int

    var description: String {
        "\(path) +\(additions)/-\(deletions)"
    }
}

// MARK: - GitHub Service

enum GitHubService {
    static func prList(username: String, limit: Int = 1) throws -> String {
        let outputString = try Fork.exec("/usr/local/bin/gh", args: ["pr", "list", "-A", username, "-s", "open", "--json", "number,title,url,files"])
        guard let outputData = outputString.data(using: .utf8) else {
            throw Errors.dataConversionError
        }

        let prs = try JSONDecoder().decode([PRModel].self, from: outputData)
        let output = prs.prefix(limit).map { model in
            let loc: Int = model.files.reduce(into: 0) { partialResult, file in
                partialResult += file.additions
            }
            return "* PR#\(model.number) \(model.url)\n\t* \(model.title) [LOC: \(loc)]"
        }

        guard !output.isEmpty else {
            return "Zero PRs matched the preset criteria for \(username)"
        }

        let prCount = output.count
        let preface = "I need \(prCount > 1 ? "reviews" : "a review") for the following \(prCount > 1 ? "\(prCount) PRs" : "PR"):"
        return "\(preface)\n\(output.joined(separator: "\n"))"
    }
}

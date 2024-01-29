import Foundation

struct ConfigModel: Decodable {
    let github: GitHubConfigModel
    let slack: SlackConfigModel
}

struct GitHubConfigModel: Decodable {
    let username: String
}

struct SlackConfigModel: Decodable {
    let team: String
    let channel: String
}

enum ConfigService {
    static func load() throws -> ConfigModel {
        let cfgPath = "\(FileManager.default.homeDirectoryForCurrentUser).prhub"
        guard let cfgURL = URL(string: cfgPath) else {
            throw Errors.dataConversionError
        }
        let data = try Data(contentsOf: cfgURL)

        let cfg = try JSONDecoder().decode(ConfigModel.self, from: data)
        return cfg
    }
}

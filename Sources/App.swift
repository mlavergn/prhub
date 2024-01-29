@main
enum App {
    static func main() {
        do {
            let cfg = try ConfigService.load()
            let output = try GitHubService.prList(username: cfg.github.username, limit: 3)
            print(output)
            try SlackService.open(team: cfg.slack.team, channel: cfg.slack.channel)
        } catch {
            print("ERROR:", error.localizedDescription)
        }
    }
}

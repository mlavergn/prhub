# prhub

Pull Request Tool for GitHub

Pre-requisites:

- Xcode installed
- GitHub CLI tool installed in path
  - https://github.com/cli/cli
- `prhub.json` configured and copied to `~/.prhub`

Example:

```bash
demo% cd myrepo
demo% prhub

I need reviews for the following 2 PRs:
* PR#1234 https://github.example.com/myrepo/pull/1234
    * Some code change [LOC: 12]
* PR#4321 https://github.example.com/myrepo/pull/4321
    * Some other code change [LOC: 8]
```

The above will list the newest 3 open PRs for the user configured in `~/.prhub`.

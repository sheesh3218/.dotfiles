![screenshot](./docs/assets/img/presentation.jpg)

## Overview

> This project is a collection of my personal dotfiles for my macOS environment.

It contains the configuration files for the following tools:

- [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- [Git](https://git-scm.com/)
- [Zsh](https://www.zsh.org/)
- [iTerm2](https://iterm2.com/)
- [yabai](https://github.com/koekeishiya/yabai)
- [Homebrew](https://brew.sh/)
- [GitHub](https://github.com)

This project is the continuity of these previous projects:

- [Easy-Git](https://github.com/MorganKryze/easy-git)
- [Easy-Env](https://github.com/MorganKryze/easy-env)
- [Yabai-Setup](https://github.com/MorganKryze/yabai-setup)
- [Mac-Setup](https://github.com/MorganKryze/mac-setup)

## Getting Started

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Documentation](#documentation)
  - [Setting up](#setting-up)
    - [Prerequisites](#prerequisites)
    - [Install](#install)
    - [Post-installation](#post-installation)
  - [Troubleshooting](#troubleshooting)
  - [Future improvements](#future-improvements)
  - [Contributing](#contributing)
  - [License](#license)

### Documentation

Provide where to find to the documentation of the project. (ex: [Structure of the project](./docs/STRUCTURE.md))

- [General utility packages](./docs/tools/general.md)
- [Dev packages](./docs/tools/dev.md)

It may include a link to an important [reference](https://example.com).

### Setting up

#### Prerequisites

- macOS Sonoma (14.x.x)
- Internet connectivity
- A terminal

#### Install

After booting up your Mac for the first time, **restart it** and follow the steps below.

Open a terminal using spotlight : [cmd + space] then type "terminal" and press enter.

Then execute the command below and follow the instructions:

```bash
curl -s https://raw.githubusercontent.com/sheesh3218/.dotfiles/main/scripts/bootstrap.sh | zsh
```

#### Post-installation

Add `cmd+d` as a shortcut to `Show Launchpad` in `System Preferences > Keyboard > Shortcuts > Launchpad & Dock`.

Start by opening each of the ObjectiveSee apps and grant them the necessary permissions when prompted.

Then you may open the rest of the apps at least once and make the necessary configurations.

After setting up at least `Bitwarden` and `Arc` / `Zen`, sign in to your GitHub and GitLab accounts.

Then, run the following command to create the SSH connections to your Git accounts:

```bash
create-git-ssh-connections
```

Finally, run the following command launch the yabai service and grant the necessary permissions:

```bash
yabai-start
```

Your machine is now set up and ready to use!

### Troubleshooting

No Issues reported so far!

### Future improvements

- [ ] document the brew packages (similar to [Mac-Setup](https://github.com/MorganKryze/mac-setup))
- [ ] document and improve [Easy-Git](https://github.com/MorganKryze/easy-git) work
- [ ] document and improve [Easy-Env](https://github.com/MorganKryze/easy-env) work
- [ ] document and improve [Yabai-Setup](https://github.com/MorganKryze/yabai-setup) work

### Contributing

If you want to contribute to the project, you can follow the steps described in the [CONTRIBUTING](./.github/CONTRIBUTING) file.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

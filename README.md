# dev-setup

This repository contains everything that you need to automatically setup a development environment.

`master` is the starting point and does nothing on its own. The intention is that you will fork this repository a configure it to setup your development environment just the way that you like it. Follow the instructions below on [creating a fork](#creating-a-fork). See [example](example-branch) for an example of how you can configure `dev-setup`. (TODO: replace this section on customisations)

## Usage

### Setting up your development environment

⚠️ WARNING: These commands will execute code on your machine. Never run code that you do not trust. You should read the [code](https://raw.githubusercontent.com/BotTech/dev-setup/3497553571b3ff580478621cf278e21a1989a575/bootstrap.sh) (also check that the URL matches the one above).

⚠️ DISCLAIMER: While we endeavor to make these scripts free from bugs we cannot guarantee that these scripts will not cause unwanted side effects. It is your responsibility to take adequate backups to ensure that you can recover from any issues. If you find any issues with these scripts then please report them.

#### macOS

Run the following command in a terminal:
```bash
bash <(curl -s https://raw.githubusercontent.com/BotTech/dev-setup/3497553571b3ff580478621cf278e21a1989a575/bootstrap.sh)
```

#### Windows

TODO

#### Linux

```bash
bash <(wget -q -O - https://raw.githubusercontent.com/BotTech/dev-setup/3497553571b3ff580478621cf278e21a1989a575/bootstrap.sh)
```

## Forking

### Creating a fork

1. [Fork the original repository](fork-do-not-change-this).*
1. Clone your fork.
1. Edit `README.md` and update the URL in the previous section to point to raw `bootstrap.sh` script. (TODO: add a script that does this)
1. Edit the XXX file (TODO).

\* It is recommended that you only clone the original repository as there may be a lag in the intermediary repository getting updates from upstream. If you find a fork which has things that the original repository doesn't have then encourage the maintaner (or submit a PR yourself) to contribute these changes.

[fork-do-not-change-this]: https://github.com/BotTech/dev-setup/fork
[example-branch]: https://github.com/BotTech/dev-setup/blob/example


# dev-setup

This repository contains everything that you need to setup a new development environment.

`master` is intentionally an oppinionated setup. The point is that you fork this repository and create your own setup, just how you like it, reusing which ever modules you want.

## Usage

### Setting up your development environment

Run the following command in a terminal:
```bash
bash <(curl -s https://raw.githubusercontent.com/BotTech/dev-setup/93df30a8318d0606a797990fa9ae9a67ca743359/dev-setup.sh)
```
or
```bash
bash <(wget -q -O - https://raw.githubusercontent.com/BotTech/dev-setup/93df30a8318d0606a797990fa9ae9a67ca743359/dev-setup.sh)
```

⚠️ WARNING: These commands will execute code on your machine. Never run code that you do not trust. You can read the [code](https://raw.githubusercontent.com/BotTech/dev-setup/93df30a8318d0606a797990fa9ae9a67ca743359/dev-setup.sh) here (check that the URL matches the one above).

### Creating a fork

1. [Fork the original repository](fork-do-not-change-this).*
1. Clone your fork.
1. Edit `README.md` and update the URL in the previous section to point to raw `dev-setup.sh` script.
1. Edit the XXX file (TODO).

\* It is recommended that you only clone the original repository as there may be a lag in the intermediary repository getting updates from upstream. If you find a fork which has things that the original repository doesn't have then encourage the maintaner (or submit a PR yourself) to contribute these changes.

[fork-do-not-change-this]: https://github.com/BotTech/dev-setup/fork


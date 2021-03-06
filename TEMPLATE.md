# dev-setup

This repository contains everything that you need to automatically setup a development environment.

## Usage

### Setting up your development environment

⚠️ WARNING: These commands will execute code on your machine. Never run code that you do not trust. You should read the [code](https://raw.githubusercontent.com/BotTech/dev-setup/33a2340fbd24a47ab0d59fb773b0d168dac16747/bin/bootstrap.sh) (also check that the URL matches the one above).

⚠️ DISCLAIMER: While we endeavor to make these scripts free from bugs we cannot guarantee that these scripts will not cause unwanted side effects. It is your responsibility to take adequate backups to ensure that you can recover from any issues. If you find any issues with these scripts then please report them.

#### macOS

Run the following command in a terminal:
```bash
bash <(curl -s https://raw.githubusercontent.com/BotTech/dev-setup/33a2340fbd24a47ab0d59fb773b0d168dac16747/bin/bootstrap.sh) setup
```

#### Windows

TODO

#### Linux and Windows Subsystem for Linux

```bash
bash <(wget -q -O - https://raw.githubusercontent.com/BotTech/dev-setup/33a2340fbd24a47ab0d59fb773b0d168dac16747/bin/bootstrap.sh) setup
```
\* Some flavours of Linux do not have `wget` installed. If you have `curl` then use the command for [macOS](#macos). Otherwise you will have to download and run [bin/bootstrap.sh](https://raw.githubusercontent.com/BotTech/dev-setup/33a2340fbd24a47ab0d59fb773b0d168dac16747/bin/bootstrap.sh) manually.


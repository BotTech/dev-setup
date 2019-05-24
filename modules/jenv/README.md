# jenv module

## Usage

When adding `jenv` to `config/*/modules`, make sure to put it after any JVM modules so that `jenv` can add them
automatically.

If using `zsh` and `antigen` then make sure that you add the [jenv plugin][jenv-plugin]
(`robbyrussell/oh-my-zsh path:plugins/jenv`) to `config/*/module-config/antigen/.zsh_plugins.txt`.

[jenv-plugin]: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jenv

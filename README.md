# Moto-cd

Moto-cd (multi-auto-cd) is a slightly modified version of https://github.com/andreaconti/auto-cd made just for fun.

-----------------------------

I find really useful open many shells in the same folder and is really annoying for each of them `cd` in that folder, even using the awesome z plugin.

moto-cd simply remembers the last folder you visited using `cd` and when you will open a new shell it will automatically jump into it.

## Install

- manual installation in oh-my-zsh

To manually install in oh-my-zsh you need to download and copu inside 
`$ZSH_CUSTOM/plugins`

```zsh
git clone https://github.com/timka/moto-cd $ZSH_CUSTOM/moto-cd
```
Then activate in your `.zshrc`.

```zsh
plugins=(moto-cd)
```

- antigen

Installing using antigen is quite simple:

```zsh
antigen bundle timka/moto-cd
```

## Options

`moto-cd` provided few options:

- MOTO_CD_HOME, the default folder into which to jump if there is no previous `cd`
- MOTO_CD_NO_MOTO_LS, bool, if true disables auto-ls once entered in the new folder
- MOTO_CD_FILE, the file where previous `cd` is stored (defaults to `~/.last_cd`)

MOTO_CD_FILE may be set dynamically, for instance, in ~/.ssh/authorized_keys to switch workspaces/contexts/projects.

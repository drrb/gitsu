---
layout: minimal
title: Command Line Reference
---

## Gitsu Command Line Reference

### Usage

`git su [OPTIONS] [user...]`


### Options

`-a, --add USER`

Add a user to the Gitsu users. Should be in the format `John Galt <jgalt@example.com>`. You can quickly switch to one of these users by supplying a `user` argument to Gitsu.

`-c, --clear`

Clear all Git users. If a scope (`--local`, `--global`, or `--system`) is specified, only clear that scope's user.

`-e, --edit`

Open the Gitsu config in an editor. This is the same editor that Git is configured to use for config files.

`-h, --help`

Show help.

`-l, --local, -g, --global, -s, --system `

Specify the scope for printing, switching, or clearing selected users.

`-t, --list`

List the Gitsu users.

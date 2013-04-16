---
layout: minimal
title: Configuration
---
## Configuration

Gitsu supports the following configuration options, specified either in Git config
files, or by executing `git config`:

`gitsu.defaultSelectScope`
One of "local", "global", or "system" (without quotes).
Specifies the default scope that the user is switched in when `git su` is run.

`gitsu.groupEmailAddress`
The group email address to use when switching to multiple users.
E.g., if you specify "developers@company.org", pairing email addresses will look like "developers+me+you@example.org".
Defaults to "dev@example.com".

`color.ui`
Gitsu respects the value of `color.ui` in the same way Git does.
That is, output is colored only if `color.ui` is set to true, and stdout is a TTY.

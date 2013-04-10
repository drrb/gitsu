# Gitsu

[![Build Status](https://travis-ci.org/drrb/gitsu.png)](https://travis-ci.org/drrb/gitsu)
[![Coverage Status](https://coveralls.io/repos/drrb/gitsu/badge.png?branch=master)](https://coveralls.io/r/drrb/gitsu)
[![Code Climate](https://codeclimate.com/github/drrb/gitsu.png)](https://codeclimate.com/github/drrb/gitsu)

Gitsu helps to manage your Git users, by making it easy to switch
between users. Gitsu also supports pair programming by allowing you
switch to multiple users at once!

## Installation

    $ gem install gitsu

## Usage

Gitsu is intended to be used from the command line, through Git.

To switch the configured Git user:

    $ git su "John Galt <jgalt@example.com>"

    Switched local user to John Galt <jgalt@example.com>

To make it easier to switch users, tell Gitsu about some users.

    $ git su --add "John Galt <jgalt@example.com>"
    $ git su --add "Raphe Rackstraw <rrack@example.com>"
    $ git su jg

    Switched to user John Galt <jgalt@example.com>

    $ git su raphe

    Switched to user Raphe Rackstraw <rrack@example.com>

To pair with your friend switch to both users at once

    $ git su jg rr

    Switched to user John Galt and Raphe Rackstraw <jgalt+rrack+dev@example.com>

## Documentation

For more information, see [the documentation](http://drrb.github.com/gitsu)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

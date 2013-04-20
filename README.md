# Gitsu

[![Build Status](https://travis-ci.org/drrb/gitsu.png)](https://travis-ci.org/drrb/gitsu)
[![Coverage Status](https://coveralls.io/repos/drrb/gitsu/badge.png?branch=master)](https://coveralls.io/r/drrb/gitsu)
[![Code Climate](https://codeclimate.com/github/drrb/gitsu.png)](https://codeclimate.com/github/drrb/gitsu)

[![Gem Version](https://badge.fury.io/rb/gitsu.png)](http://badge.fury.io/rb/gitsu)

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

    Switched local user to John Galt <jgalt@example.com>

    $ git su raphe

    Switched local user to Raphe Rackstraw <rrack@example.com>

To pair with your friend switch to both users at once

    $ git su jg rr

    Switched local user to John Galt and Raphe Rackstraw <dev+jgalt+rrack@example.com>

## Documentation

For more information, see [the documentation](http://drrb.github.io/gitsu)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes, and add tests for them
4. Test your changes (`rake`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## License

Gitsu
Copyright (C) 2013 drrb

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

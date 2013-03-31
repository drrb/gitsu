---
layout: minimal
---

## Installation

Gitsu can be installed as [a Ruby Gem](https://rubygems.org/gems/gitsu)

{% highlight console %}
$ gem install gitsu
{% endhighlight %}

## Getting Started

Gitsu is intended to be used from the command line, through Git.

Without any configuration, you can use it to switch the configured Git user:

{% highlight console %}
$ git su "John Galt <jgalt@tcmc.com>"

Switched local user to John Galt <jgalt@tcmc.com>
{% endhighlight %}

To make it easier to switch users, tell Gitsu about some users.

{% highlight console %}
$ git su --add "John Galt <jgalt@example.com>"
$ git su --add "Raphe Rackstraw <rack@example.com>"
$ git su jg

Switched to user John Galt <jgalt@example.com>

$ git su raphe

Switched to user Raphe Rackstraw <rack@example.com>
{% endhighlight %}

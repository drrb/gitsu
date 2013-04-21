---
layout: minimal
title: Getting Started
---

### Installation

Gitsu can be installed as [a Ruby Gem](https://rubygems.org/gems/gitsu)

{% highlight console %}
$ gem install gitsu
{% endhighlight %}

### Getting Started

Gitsu is intended to be used from the command line, through Git. Note that all command line
switches also have [short versions](/gitsu/cli).

Without any configuration, you can use it to switch the configured Git user:

{% highlight console %}
$ git su "John Galt <jgalt@example.com>"
Switched local user to John Galt <jgalt@example.com>
{% endhighlight %}

To make it easier to switch users, tell Gitsu about some users.

{% highlight console %}
$ git su --add "John Galt <jgalt@example.com>"
User 'John Galt <jgalt@example.com>' added to users
$ git su --add "Raphe Rackstraw <rack@example.com>"
User 'Raphe Rackstraw <rack@example.com>' added to users

$ git su jg
Switched to user John Galt <jgalt@example.com>
$ git su raphe
Switched to user Raphe Rackstraw <rack@example.com>
{% endhighlight %}

You can also switch to multiple users, for pairing:

{% highlight console %}
$ git su jg rr
Switched to user 'John Galt and Raphe Rackstraw <dev+jgalt+rack@example.com>'
{% endhighlight %}

Now check out the [usage examples](/gitsu/usage).

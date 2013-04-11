---
layout: minimal
title: Usage
---
## Usage Examples

### Checking current users

Show current Git users in all scopes

{% highlight console %}
$ git su
Current user: Raphe Rackstraw <rrack@example.com>

Local: Raphe Rackstraw <rrack@github.com>
Global: Raphe Rackstraw <rrack@example.com>
System: (none)
{% endhighlight %}

Show the current Git users in specified scopes

{% highlight console %}
$ git su --local --global
Current user: Raphe Rackstraw <rrack@example.com>

Local: Raphe Rackstraw <rrack@github.com>
Global: Raphe Rackstraw <rrack@example.com>
System: (none)
{% endhighlight %}

Show the current Git user that Git would use to commit

{% highlight console %}
$ git whoami
Raphe Rackstraw <rrack@example.com>
{% endhighlight %}

### Adding users

To add a user to Gitsu (the user will be saved in `~/.gitsu`)

{% highlight console %}
$ git su --add 'Raphe Rackstraw <rrack@example.com>'
{% endhighlight %}

You can also add users manually to `~/.gitsu` in the following format:

{% highlight yaml %}
jporter@example.com: Sir Joseph Porter KCB 
rrack@example.com: Raphe Rackstraw
{% endhighlight %}

### Switching users

Switch to configured users by initials

{% highlight console %}
$ git su jp
Switched to Joseph Porter KCB <jporter@example.com>
{% endhighlight %}

or by part of their name

{% highlight console %}
$ git su straw
Switched to Raphe Rackstraw <rrack@example.com>
{% endhighlight %}

To clear all Git users

{% highlight console %}
$ git su --clear
Clearing all users from Git config
{% endhighlight %}

### Scopes

Gitsu supports Git's configuration scopes: local (current repository), 
global (current OS user), and system (everyone on the system). As in Git, if you 
don't specify a scope, local scope is assumed.

To change the user for a specific scope

{% highlight console %}
$ git su joe --system
Switched system user to Joseph Porter KCB <jporter@example.com>
{% endhighlight %}

To clear the user for a specific scope

{% highlight console %}
$ git su --clear --global
Clearing Git user in global scope
{% endhighlight %}
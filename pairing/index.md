---
layout: minimal
title: Pairing
---

### Pairing with Gitsu

#### Switch to two users

First, add some users:

{% highlight console %}
$ git su --add 'Raphe Rackstraw <rrack@example.com>'
User 'Raphe Rackstraw <rrack@example.com>' added to users
$ git su --add 'Joseph Porter KCB <joe@example.com>'
User 'Joseph Porter KCB <joe@example.com>' added to users
{% endhighlight %}

Then, switch to them:
{% highlight console %}
$ git su joe rack
Switched local user to 'Joseph Porter KCB and Raphe Rackstraw <dev+joe+rrack@example.com>'
{% endhighlight %}

#### Switch to multiple users

If you need to switch to more than two users at once:
{% highlight console %}
$ git su --add 'Josephine Corcoran <jc@example.com>'
User 'Josephine Corcoran <jc@example.com>' added to users
$ git su joe rack jc
Switched local user to 'Joseph Porter KCB, Josephine Corcoran and Raphe Rackstraw <dev+joe+jc+rrack@example.com>'
{% endhighlight %}

#### Configure group email

You can change the group email that Gitsu uses when combining your users' email addresses,
via a config entry

{% highlight console %}
$ git config --global gitsu.groupEmailAddress 'web@example.org'
$ git su rack jc
Switched local user to 'Josephine Corcoran and Raphe Rackstraw <web+joe+jc+rrack@example.org>'
{% endhighlight %}


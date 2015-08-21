---
title: 04. Development Environment
order: 4
---

Since most of our time with the startup stack will be spent configuring, adding
and creating chef cookbooks and recipes, we'll need to setup a Ruby development
environment.

There are two ways to start working

1. Vagrant
2. Run everything on your machine

If you want to get started quickly, Vagrant is likely your best bet, but you
mind find it cumbersome to SSH into a virtual box just to communicate with your
chef-server.

In which case, going with running everything on your machine is best. The
choice is yours and support will be provided for both ways.

## Getting Started

In order to get started with either, you will first have to fork the cookbooks
repository to your machine.

I recommend forking it to your account and starting to work on your version
right off the bat, it'll be easier going forward.

Visit this link
[https://github.com/the-startup-stack/stack-cookbooks/fork](https://github.com/the-startup-stack/stack-cookbooks/fork) and fork the repo to the account you want.

## Vagrant

* Download and install Vagrant from: https://www.vagrantup.com/downloads.html
* Download and install VirtualBox from: https://www.virtualbox.org/wiki/Downloads
* Run `ssh-add -k` This will add your private key to the SSH agent for Vagrant
* Run `vagrant up`

Make sure you run `vagrant up` **inside** the directory which you cloned the
project to.

For example, if you cloned the repo to `~/Code/stack-cookbooks`, that's where
those commands need to run

## Run everything on your machine

If you have Ruby (Rbenv/RVM) already installed on your machines it's even
simpler to get started.

Once you cloned the repo you'll need to run these commands

```
$ bundle install --binstubs --path .bundle
$ bin/librarian-chef install
```

That's it, you are now ready to start working.

---
title: 04. Knowing The Project Structure
order: 4
---

In order to get started, lets first familiarize with the stack cookbooks.

The cookbooks repo located here:
[https://github.com/the-startup-stack/stack-cookbooks](https://github.com/the-startup-stack/stack-cookbooks) is actually a bit more then just the cookbooks, it's everything you need to bootstrap your initial cluster.

The Structure

```
├── Cheffile
├── Cheffile.lock
├── Gemfile
├── Gemfile.lock
├── bin
├── bundle
├── cookbooks
├── dockerfiles
├── environments
├── roles
├── site-cookbooks
└── terraform
  ```
  
Lets dive into these
  
### Cheffile/Cheffile.lock

Those are exactly like Gemfiles, meaning this will tell the `librarian-chef` command (you'll see where we use it later), which version to download. This essentially locks the development against specific versions of the cookbooks.

### Gemfile/Gemfile.lock

These are Rubygems that we use during the development of the cookbooks.

### bin/bundle

Those are bundle and binstubs for ruby.

### cookbooks

All the cookbook dependencies.

Mind you, this directory is there for `librarian-chef`, even if you find something you need to change there (which you should not), never change it in place. You need to fix the cookbook and deploy it to Gibhub and update through librarian.

I know this sounds a bit complex, but we'lll get there.

### dockerfiles

This is where we put all the Dockerfile for the project.

### environments

The startup stack comes right out of the gate with pre-built support for environemtns. This means you have `development`, `staging` and `production` by default.

The environment files are just JSON files that lock cookbook versions on the `chef-server` for specific environments.

For example, lets say we are working on the `stack-logger` cookbook, we want to bump the version only on `development` and `staging` all the while `production` is locked to previous version and can run chef without worrying about new bugs.

### roles

The stack does not run cookbooks on servers or instances without a defined role.

Roles are ways to tell chef which cookbooks to run but in a more declarative way.

For example, one of the roles we have is `base`, this is the role for **all** instances, and we have `stats` role for graphite.

So, Graphite server essentially will be bootstrapped with `base` and `stats`.

Don't worry too much about the terminology right now, it'll be explained further when we need it.

### site-cookbooks

This is **our** cookbooks. this is where we customize the behavior for our servers.

### terraform

Terraform configurations.

Configurations are devided into logical directories in order to make sure the files are manageable

## Summarizing

This project is big, we try to put everything in place.

It should be pretty straight forward to navigate around the project.
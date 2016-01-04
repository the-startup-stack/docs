---
title: The Road Map
permalink: /roadmap/
order: 1
---

The plans for the project are big, right now there are a few things planned.
Those are not in order of importance.

## More tooling around AMI and machine images

Right now the bootstrapping phase for a server takes too long (3-5 minutes).
This has to be better.

The plan is to have tooling that will create AMIs for the `base` image and the
`web` image using Packer. This will allow the bootstrapping process to focus on
the application needs and not on the machine needs.

## CI Tools

The thing missing the most right now in the stack is a CI.

CI is a very opinionated decision and basically it's left out since the energy
to set it up in a way that will be generic is too great.

The plan is to have tooling that any CI server will be able to use. Something
like a shell script that you run on your CI that will allow you to run packer
builds and other needs.

## Generic cookbooks

This version of the cookbooks are simply extracting a running startup,
anonimizing the cookbooks and making them open source. While this is valid for
the short run, in the long run it will need to change.

More usage of generic resources, less usage of attributes and include-all
recipes.

## Service recipes

Having a generic way to launch a "service" is something that should be included
as well. Developers should not really think of service configuration and other
Devopsy things. Having a recipe that you can throw that will be your service
definition is something that will be included in the future.

## Simplifying Amazon IAM and instance creation

Right now the whole Amazon IAM and instance creation for the first time is too
cumbersome. This should be simplified into command line tool that will create
everything in idempotent way that is less prone to errors and mistakes.

This will also follow best practices into sandboxing permissions to users that
need it.

## Using Amazon's Route53 for internal DNS

Right now the domain resolving solution is too simplistic. When something
changes (say an IP change in the monitoring service) there needs to be
a provision across too many things in order to propagate that change.

Using Amazon's route53 as an internal DNS will solve a lot of these problems

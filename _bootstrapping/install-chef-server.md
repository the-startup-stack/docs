---
title: Install Chef Server
order: 1
---

First thing you need in order to get started creating your stack is provisioning a chef-server.

## Why?

Chef server is a great way to centralize configuration across your cluster.

Even in this day an age with containers, you will still need a centralized
configuration management solution that will orchestrate everything in your
organization.

For example: Creating images, configuring instances for placement in auto
scaling groups and so much more.

You get a fine-grained control over what you apply to your cluster. You can
support incremental environment changes and more.

Chef server will save state of each of the nodes, allowing you to check out what's going on with each of the servers.

## Environment support

Pretty much every startup has the concept of environments (eg: production,
staging). While you work on changing the configuration you can actually "lock"
production on stable versions and continue working on the other environments.

Lets say you want to upgrade Ruby on the rails servers, you want to make sure
nothing breaks. (of course testing is required before).

You can "bump" the ruby cookbook to staging only while production servers will
still be converged with the previous version.

## Provisioning a chef server

You have 2 options to converge a chef server. You can do it on-premise, which
will install the software on one of your instances or you can use chef saas to
do so.

If you are starting off, I strongly recommend you go with the SAAS version.
It's easy to migrate over once you want it on-premise.

1. [Managed Chef](/bootstrapping/managed-chef/)
2. [On Premise](/bootstrapping/on-premise-chef/)

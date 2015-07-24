---
title: 02. Install Chef Server
order: 2
---

First thing you need in order to get started creating your stack is installing chef-server.

## Why

Chef server is a great way to centralize configuration across your cluster.
The startup stack uses data bags in order to store configuration, some secrets, keys, api keys and more.

## Control over your cluster

Chef server will save state of each of the nodes, allowing you to check out what's going on with each of the servers.

## Environment support

We use chef with Omni, which is a great way to support environments, you can push cookbooks changes to staging/dev without production being affected.

Once you tested and verified everything is working on the staging environment you can push the cookbook to staging and use knife to run chef-client on all the instances, distirbuting the configuration change in minutes across your cluster.

### Installation

Since Chef Server install process is pretty well documented, just head over to the chef docs in order to start.

You can find the docs here: http://docs.chef.io/server/install_server.html

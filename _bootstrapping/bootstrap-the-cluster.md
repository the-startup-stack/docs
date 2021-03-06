---
title: Bootstrapping the cluster
order: 2
---

## Cluster / Orchestration solution

In order to achieve a true modern stack, we need a cluster orchestrator. This
is achieved using [mesos](http://mesos.apache.org/), [marathon](https://mesosphere.github.io/marathon/)
and [chronos](http://mesos.github.io/chronos/).

This project will mature around these, once the project includes some
executables it will likely come pre-configured with marathon configuration and
HA-Proxy bridge.

Each and every one of the machines in the cluster are "slaves" orchestrated by
the master.

The default installation (for now) includes a single master that has everything
on it mesos, zookeeper and marathon

In order to bootstrap the cluster go to `terraform/cluster` and execute the
following commands.

```
$ export $MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"`
$ terraform get
$ terraform apply -var key_name=production -var your_ip_address=$MY_IP
```

This will start a new server instance for you.

After you bootstrap the server, terraform will spit out an IP for you, you use
this IP in order to configure the serevr with chef.

```
$  bin/knife bootstrap YOUR_SERVER_IP -r "role[base],role[marathon]" -E production -x ubuntu --sudo
```

This will install everything and start all the services you need on that
server.

You are now ready to deploy services using Mesos and Marathon.

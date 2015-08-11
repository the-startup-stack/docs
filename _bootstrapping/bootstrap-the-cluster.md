---
title: 02. Bootstrapping the cluster
order: 2
---

This is a completely optional stage and you can delay this to later when you
are ready to think about working in a cluster and deploying docker containers.

The startup stack comes ready with mesos, zookeeper, marathon and slave
configuration in order to make sure you can get started relatively easily with
deploying applications to a cluster.

This project will mature around these, once the project includes some
executables it will likely come pre-configured with marathon configuration and
HA-Proxy bridge.

The default installation (for now) includes a single master that has everything
on it mesos, zookeeper and marathon

In order to bootstrap the cluster go to `terraform/base` and execute the
following commands.

```
$ export $MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"`
$ terraform apply -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.marathon
```

This will bootstrap the server for you.

After you bootstrap the server, terraform will spit out an IP for you, you use
this IP in order to configure the serevr with chef.

```
$  bin/knife bootstrap YOUR_SERVER_IP -r "role[base],role[marathon]" -E production -x ubuntu --sudo
```

This will install everything and start all the services you need on that
server. 

You are now ready to deploy services using Mesos and Marathon.

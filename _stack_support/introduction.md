---
title: Introduction
permalink: /stack_support/
order: 1
---

The stack support section includes the "Global" parts that support your stack.

No matter if you are running a rails/django/node.js shop, those parts are still
there for your support.

## What does the stack support include?

### Logging

Logging is provided by Kibana, ElasticSearch and Logstash, pre-configured to
ship logs throug Rsyslog shipper over TCP/UDP

### Monitoring

Monitoring is done by Sensu and configured to monitor disk space, CPU, Memory
and comes with a lot of documentation of other monitoring additions you can do.

### Stats

The reliable Graphite controls stats, shipping through StatsD so you don't
block your apps with TCP connections.

## Cluster Membership (V2)

Since Mesos is a first class citizen in this project, cluster membership
solution is key. This will be added in V2 (Check out Roadmap for details)

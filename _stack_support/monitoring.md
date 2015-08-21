---
title: Monitoring
order: 2
---

Monitoring in the-startup-stack is provided by [Sensu](https://sensuapp.org/).

Sensu can monitor basically anything and it has a very intuitive DSL (Ruby).
You can verify KPIs, you can monitor speed, disk, CPU and even less obvious
stuff like a server trailing behind in deployment.

Sensu also has loads of [community driven plugins](https://sensuapp.org/plugins) that you can checkout.

Sensu is built on a messaging architecture, driven by RabbitMQ. Here's an
overview of the sensu architecture.

{% imgcap http://assets.avi.io/sensu-diagram-87a902f0.gif %}

## Recipes

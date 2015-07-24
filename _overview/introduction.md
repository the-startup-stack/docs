---
title: Introduction
permalink: /
order: 1
---

The startup stack is an attempt on helping startup bootstrapping their stack in
the cloud.

While lots of startups have different technologies, often the underlying stack
is very similar, yet, lots of startup are left to figure this out as they go
along.  
This creates many challenges. Lots of PAAS companies try to solve that by
abstracting away the complexity, but you are sometimes left locked in to a
platform and migrating away is really hard.

Lets take a very common startup launching a product on the web and mobile, even
without talking about the language or framework of choice they'll need to
figure out monitoring, deployment, load balancing, debugging, logging and so
many more things. Each of these brings challenges along

## Modern and current by default

The stack will be current and modern by default, this doesn't mean we'll drop the **docker** bombs on you but it will be a production cluster, thinking of containers when appropriate and instances where not.

For example, Mesos, Maraton, Docker, and ZooKeeper are first class citizens, also all configuration of servers will be done with chef and in a centralized way, meaning you get a chef server that will manage all of the nodes allowing you to know exactly what's going on in your cluster at all times.

## Sane Defaults

With infrastructure, there's no "catch all", it's a tailored production, but still, having sane defaults is super important.  
For example, when you deploy graphite, the disk size, speed, ports opened and other configuration will be pre-defined for something that will work long-term in most production evnironments.

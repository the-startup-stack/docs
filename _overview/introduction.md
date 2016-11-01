---
title: Introduction
permalink: /
order: 1
---

## What is the startup stack?

The startup stack is an attempt to help startups bootstrap their stack in
the cloud.

While lots of startups have different technologies, the underlying stack
is often very similar; yet, many startups are left to figure this out as they go
along.

This creates many challenges. PaaS companies try to solve them by
abstracting away the complexity, but startups still sometimes find themselves locked into a platform because migrating away is really hard.

Let's look at a very common scenario: a startup launches a product on the web and mobile. Even without talking about the language or framework of choice, they'll need to figure out monitoring, deployment, load balancing, debugging, logging and so many more things. Each of these brings challenges along the way.

## Modern and current by default

**The Startup Stack's** approach will be current and modern by default. This doesn't necessarily mean we'll drop **docker** bombs on you, but it will be a production cluster, thinking of containers when appropriate and instances where not.

## Sane Defaults

With infrastructure, there's no "catch all". It's a tailored production, but still, having sane defaults is super important.

For example, when you deploy graphite, the disk size, speed, ports opened, and other configurations will be pre-defined for something that will work long-term in most production environments.

---
title: Ruby on Rails
order: 1
---

The Rails stack is actually an all-inclusive web-server architecture.

If we simplify the architecture to the most basic component, this is what it
looks like:

{% imgcap http://assets.avi.io/screen-shot-2015-12-16-8105h.png%}

## Components

### Frontend servers

Frontend servers are the main entry point of your users when they come from
a web browser. This will be your main Rails application.

### API servers

API servers are the endpoint to the mobile applications. They are behind
a different load balancer. The purpose of this is to separate the failures of
those systems and the load balancing.

### Backend Servers

Backend servers are closed to the public, they have no access to them. Those
servers host Sidekiq, Cache warmers, backend callbacks and anything else that
is not organic web/API traffic.

## Bootstrapping a server

Right now, bootstrapping a server is **not** included in terraform. The way to
launch a server is old-school bootstrapping with AWS command line.


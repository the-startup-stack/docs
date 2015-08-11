---
title: Logging
order: 1
---

Logging is provided by logstash and Kibana, backed by ElasticSearch.

## What logging includes out of the box

Configuration for Nginx access log, Ruby on Rails JSON based logs.

Both of these are configured to be shipped to the server remotely by Rsyslog
shipping (agent configuration included as well).


## Configuration


{% include _common/aws_databag.md %}


## Adding a server

Kibana, Elasticsearch and Logstash are all configured on the same server backed
by a big and fast Amazon IO optimized disk.

Now, lets go ahead and configure a server

```
$ bin/knife data bag create aws main
```

This will open up your editor with something like this:


```javascript
{
  "id": "main"
}
```

You need to add a couple of keys to this JSON, which are your AWS keys

```javascript
{
  "id": "main"
  "aws_access_key_id": "YOUR_ACCESS_KEY",
  "aws_secret_access_key": "YOUR_SECRET_KEY"
}
```

Once you save the file it will be sent to the chef server and saved there

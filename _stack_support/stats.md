---
title: Stats
order: 3
---

Stats in the startup stack is provided by
[Graphite](http://graphite.wikidot.com/) and
[Statsd](https://github.com/etsy/statsd).

Here's a very basic drawing explaining how this works. Each of the hosts on
your stack has a collector, this collector only sends basic host specific stats
to graphite. Those include CPU, Mem etc...

{% imgcap http://assets.avi.io/graphite.png %}

In your application, you can also send custom stats to Graphite.

Here's an example for Ruby(rails) stats collection.

```
ActiveSupport::Notifications.subscribe(/process_action.action_controller/) do |*args|
   event      = ActiveSupport::Notifications::Event.new(*args)
   controller = event.payload[:controller]
   action     = event.payload[:action]
   format     = event.payload[:format] || "all"
   format     = "all" if format == "*/*"
   status     = event.payload[:status]
   key        = "#{controller}.#{action}.#{format}"

   ActiveSupport::Notifications.instrument :performance,
                                           :measurement => "action_controller.#{status}"

   ActiveSupport::Notifications.instrument :performance,
                                           :action => :timing,
                                           :measurement => "#{key}.total_duration",
                                           :value => event.duration
   ActiveSupport::Notifications.instrument :performance,
                                           :action => :timing,
                                           :measurement => "#{key}.db_time",
                                           :value => event.payload[:db_runtime]
   ActiveSupport::Notifications.instrument :performance,
                                           :action => :timing,
                                           :measurement => "#{key}.view_time",
                                           :value => event.payload[:view_runtime]
   ActiveSupport::Notifications.instrument :performance,
                                           :measurement => "#{key}.status.#{status}"
 end

 ActiveSupport::Notifications.subscribe(/performance/) do |name, start, finish, id, payload|
   StatsdIntegration.send_event_to_statsd(name, payload)
 end

 ActiveSupport::Notifications.subscribe("sql.active_record") do |name, start, finish, id, payload|
   if payload[:sql] =~ /^\s*(SELECT|DELETE|INSERT|UPDATE) /
     method = $1.downcase
     table  = nil

     # Determine the table name for instrumentation. The below regexes work on
     # mysql but not sqlite. Probably won't work on postgresql either.
     case method
     when "select", "delete"
       table = $1 if payload[:sql] =~ / FROM `(\w+)`/
     when "insert"
       table = $1 if payload[:sql] =~ /^\s*INSERT INTO `(\w+)`/
     when "update"
       table = $1 if payload[:sql] =~ /^\s*UPDATE `(\w+)`/
     end

     if table
       $statsd.increment("#{Rails.env.to_s}.active_record.#{table}.#{method}")
       $statsd.timing("#{Rails.env.to_s}.active_record.#{table}.#{method}.query_time", (finish - start) * 1000, 1)
     end
   end
end

```

## Requirements

You will need to create a databag for the graphite credentials

```
bin/knife data bag create graphite credentials
```

This should look something like this

```
{
  "name": "data_bag_item_graphite_credentials",
  "json_class": "Chef::DataBagItem",
  "chef_type": "data_bag_item",
  "data_bag": "graphite",
  "raw_data": {
    "id": "credentials",
    "user": "YOUR_GRAPHITE_USER",
    "password": "YOUR_GRAPHITE_PASSWORD"
  }
}
```

The `user` and `password` attributes will be used for the web basic auth.

## The stats recipe

### Default

Default recipe installs graphite on a dedicated machine along with a mounted
Raid volume that will give you enough space to grow.

#### Attributes

```
override['graphite']['password']
override['graphite']['url']
override['graphite']['storage_dir']
```

`password` is the web password for accessing graphite, you obviously want to
change that to something that fits your password policy.  `url` is the URL for
graphite to send stats to and to listen on, you would want to change it to the
stats hostname eg: `stats.your-company.com`.  `storage_dir` where would you
want the files to exists (Graphite files). If you chage this make sure the
mount is changed as well.


```
override['graphite']['web']['database']['NAME']
override['graphite']['web']['admin_email']
override['graphite']['carbon']['enable_udp_listener']
```

Location of the database, email and UDP listener settings. The default for the
database is the storage, UDP listener is on by default and email you should
give your Devops/IT guy/gal's email.


```
override['graphite']['package_names']['whisper']['source']
override['graphite']['package_names']['carbon']['source']
override['graphite']['package_names']['graphite-web']['source']
```

These settings are for the source location and the version. Only change them if
you know what you are looking for exactly and where to find the version.

```
override['graphite']['apache']['basic_auth']['enabled']
override['graphite']['apache']['basic_auth']['user']
override['graphite']['apache']['basic_auth']['pass']
```

Web Basic Auth settings. By default these come from a databag you will need to
create (Check the Requirements section of this doc)


## Adding a server

Navigate to `terraform/base` and execute the following commands

```
$ export MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address://" -e "s/<.*$//"`">`
$ terraform plan -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.stats
```

Make sure the plan looks good and there are nothing obviously wrong with it


Once you apply the change, it will create the server and output the public IP,
so lets do that now and create a stats server.

```
terraform apply -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.stats
```

This will output a public IP for the stats server, now we can bootstrap our
logger with chef.

```
$ export SERVER_IP=THE_SERVER_IP_YOU_GOT_FROM_TERRAFORM
$ bin/knife bootstrap $SERVER_IP -r "role[base],role[stats]" -E production -x ubuntu --sudo
```

Congrats! You have a running server, you can already start shipping stats to
this server, the firewall rules are preconfigured and everything runs smoothly.

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

## On by default

Sensu is part of the `base` role which comes on every server, the `base` role
includes the `sensu_client` role.

For very server you bootstrap that gets the `base` role, you will have
monitoring on by default and every check you define will run on that server asw
well.

## The Sensu Recipe

### Default

The `default` recipe for sensu will install and define the client service,
install community plugins and configure what's needed.

Each of the clients for sensu needs a subscription, by default the recipe will
include some.

Those subscriptions include:

* `all` -> All Messages will be received.
* `node['sensu']['subscriptions']` -> Array defining all subscription you want
  the machine to include.
* `node.name` -> Node name is part of the subscription list so you can
  subscribe specific machines to channels.
* `stack_role` -> You can define specific stack roles for instances, this too
  is part of the subscription.
* `node.chef_environment` -> The chef environment for the node.

Lets take a backend instance for example. The backend instance will have
`backend` as the `stack_role`, `production` as the chef environemt.

This means, that this instance will subscribe to all checks that include the
`backend` and `production` as well as the instance hostname which is `prod-be1`
for example.

Of course the default `all` and the strings defined in
`node['sensu']['subscriptions']` as well.

#### Attributes

The default recipe defined some attributes

* `node['uchiwa']['version']` -> Which uchiwa version to install (Defaults to
  0.7.0-1)
* `node['sensu']['use_embedded_ruby']` -> Whether to use embedded ruby (comes
  with sensu) or machine has ruby installed (Defaults to true)
* `node['sensu']['rabbitmq']['host']` -> The host for the sensu server
  (Defaults to sensu.the-startup-stack.com)

## Checks

The `checks` recipe comes with some default checks

* Redis process
* Unicorn process
* Nginx
* Cron
* CPU
* Disk Space

### Sample checks

### Checking if your sitemap is fresh

Many sites generate the sitemap.xml in a cron job. Making sure that file is
fresh on a specific server (Every other server proxies to this one to get the
fresh one).

```
sensu_check "check_sitemap_fresh" do
  command "check-mtime.rb -f /mnt/data/your-app/current/public/sitemap.xml -c 90000"
  handlers ["slack"]
  interval 3600
  subscribers ["specific-hostname-for-server"]
  additional(:notification => "Sitemap did not run for 25 hours")
end
```

### Checking if a specific process is running

```
sensu_check "check_warm_cache" do
  command "check-procs.rb -p warm_cache.rb -C 1"
  handlers ["slack"]
  interval 600
  subscribers ["specific-hostname-for-server"]
  additional(:notification => "Warm cache is down")
end
```

## Plugins

Sensu comes with many plugins (You can browse the  [Sensu Community
Plugins](https://github.com/sensu/sensu-community-plugins)).

The `plugins` recipe will flatten all the plugins and handlers into a single
directory to make sure you don't need the full path in order to call the DSL
(Trust me, it will make your life easier).

Often, you would want to make custom plugins for yourself as well. If you do,
here's what you'll need to add to the `plugins` recipe.


```
 stack_plugins_directory = "/opt/sensu-stack-plugins"

git stack_plugins_directory do
  repository "https://github.com/the-startup-stack/custom-sensu-plugins.git"
  reference "master"
  action :sync
end

ruby_block "flat stack plugins" do
  block do
    ["plugins", "handlers"].each do |dirname|
      Dir.glob("#{stack_plugins_directory}/#{dirname}/**/*").each do |name|
        new_file_name = "#{node['sensu']['directory']}/#{dirname}/#{File.basename name}"
        File.symlink name, new_file_name unless File.symlink?(new_file_name)
      end
    end
  end
end
```

## Bootstrapping a sensu server

```
$ export MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address://" -e "s/<.*$//"`">`
$ terraform plan -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.sensu
```

Once you review the plan and it makes sense, you can apply your changes to the
stack.

```
$ terraform apply -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.sensu
```

```
$ export SERVER_IP=THE_SERVER_IP_YOU_GOT_FROM_TERRAFORM
$ bin/knife bootstrap $SERVER_IP -r "role[base],role[sensu_server]" -E production -x ubuntu --sudo
```

That's it, now you have a sensu server and you are ready to start monitoring
your servers and services.


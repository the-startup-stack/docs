---
title: Install Chef Server
order: 1
---

First thing you need in order to get started creating your stack is installing chef-server.

## Why

Chef server is a great way to centralize configuration across your cluster.
The startup stack uses data bags in order to store configuration, some secrets, keys, api keys and more.

## Control over your cluster

Chef server will save state of each of the nodes, allowing you to check out what's going on with each of the servers.

## Environment support

We use chef with [spork-omni](https://github.com/jonlives/knife-spork#spork-omni), which is a great way to support environments, you can push cookbooks changes to staging/dev without production being affected.

Once you tested and verified everything is working on the staging environment you can push the cookbook to staging and use knife to run chef-client on all the instances, distirbuting the configuration change in minutes across your cluster.

### Chef Management Console as a service

Chef have a management console as a service that you can use for free. It is a great way to get you started, if you are just starting off and you just want to test things out. You might want to try that one first.

Head over to [https://manage.chef.io](https://manage.chef.io) and check it out.

If you do choose this path, all you need is to create your organization, your user, download the `knife.rb` to `~/.chef/knife.rb` and you are basically good to go.

### On permise Installation

This installation will bootstrap chef server on amazon for you, as with (almost) everything, we will do it using terraform.

<div class="alert alert-info" role="alert">
  <p>
    <h4>
      <strong>Heads Up!</strong> Before we start, just make sure you created the KeyPair as described in <a href="/getting_started/02-keys-and-policies/">Getting Started/02-get-your-keys-and-policies</a>
    </h4>
  </p>
</div>

Export your keys into env variables

```bash
  $ export AWS_ACCESS_KEY=YOUR_KEY
  $ export AWS_SECRET_KEY=YOUR_SECRET
  $ export EC2_REGION=us-west-2
```

Head over to the [cookbook repo](https://github.com/the-startup-stack/stack-cookbooks), clone it, then navigate into `terraform/base`.

Now in order to make sure everything works. run this command

```bash
  $ export $MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"`
  $ terraform plan -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.chef
```

This command assumes that the key name you created earlier is called `production`, if you named it something else, please change the name in the command.

The first part of the command (`export MY_IP`) is making sure only your public IP address will be able to ssh into the machine. This is best practice, never open SSH to the outside world.


The output should be something like this:

```bash
+ aws_instance.chef
    ami:                       "" => "ami-7f675e4f"
    availability_zone:         "" => "<computed>"
    ebs_block_device.#:        "" => "<computed>"
    ephemeral_block_device.#:  "" => "<computed>"
    instance_type:             "" => "t2.micro"
    key_name:                  "" => "production"
    placement_group:           "" => "<computed>"
    private_dns:               "" => "<computed>"
    private_ip:                "" => "<computed>"
    public_dns:                "" => "<computed>"
    public_ip:                 "" => "<computed>"
    root_block_device.#:       "" => "<computed>"
    security_groups.#:         "" => "1"
    security_groups.856292532: "" => "external_connection"
    source_dest_check:         "" => "1"
    subnet_id:                 "" => "<computed>"
    tags.#:                    "" => "1"
    tags.Name:                 "" => "chef"
    tenancy:                   "" => "<computed>"
    user_data:                 "" => "61d3767e56629bf51d35c0ba00d679fd66667607"
    vpc_security_group_ids.#:  "" => "<computed>"

+ aws_security_group.default
    description:                          "" => "Default Security Group"
    egress.#:                             "" => "1"
    egress.482069346.cidr_blocks.#:       "" => "1"
    egress.482069346.cidr_blocks.0:       "" => "0.0.0.0/0"
    egress.482069346.from_port:           "" => "0"
    egress.482069346.protocol:            "" => "-1"
    egress.482069346.security_groups.#:   "" => "0"
    egress.482069346.self:                "" => "0"
    egress.482069346.to_port:             "" => "0"
    ingress.#:                            "" => "2"
    ingress.2214680975.cidr_blocks.#:     "" => "1"
    ingress.2214680975.cidr_blocks.0:     "" => "0.0.0.0/0"
    ingress.2214680975.from_port:         "" => "80"
    ingress.2214680975.protocol:          "" => "tcp"
    ingress.2214680975.security_groups.#: "" => "0"
    ingress.2214680975.self:              "" => "0"
    ingress.2214680975.to_port:           "" => "80"
    ingress.4178298166.cidr_blocks.#:     "" => "1"
    ingress.4178298166.cidr_blocks.0:     "" => "YOUR_IP_ADDRESS/32"
    ingress.4178298166.from_port:         "" => "22"
    ingress.4178298166.protocol:          "" => "tcp"
    ingress.4178298166.security_groups.#: "" => "0"
    ingress.4178298166.self:              "" => "0"
    ingress.4178298166.to_port:           "" => "22"
    name:                                 "" => "external_connection"
    owner_id:                             "" => "<computed>"
    vpc_id:                               "" => "<computed>"
```

<div class="alert alert-warning" role="alert">
  <h4>
    <strong>Heads Up!</strong> Before you continue applying the terraform config, make sure to look at userdata.sh in order to change the username/password settings to your preferred credentials.
    </h4>
</div>

Now that we see that the plan works, we can bootstrap out chef server.

```bash
$ terraform apply -var key_name=production -var your_ip_address=$MY_IP -target=aws_instance.chef
```

This command will do the following

1. Create a security group and allow you to SSH into server from the IP address you are currently in.
2. Create the instance
3. Download chef server to the instance and install it and configure it

Once you apply, you should see the result something like this:

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate

Outputs:

  address = SERVER_ADDRESS
```

As you can see the output is the public DNS for the server we just created.

Usually, Chef server installation is a very manual process, however, I really did my best to make sure it's preconfigured to work properly for you right out of the gate. If it's not, please [open an issue](https://github.com/the-startup-stack/stack-cookbooks/issues/new)

Now, give chef about 10 minutes to install completely, it will run multiple commands, create the users and everything you need.

Now, download the validator keys

```bash
  $ mkdir -p .chef
  $ scp ubuntu@SERVER_ADDRESS:/tmp/stack-validator.pem .pem
  $ scp ubuntu@SERVER_ADDRESS:/tmp/stack.pem .chef/stack.pem
```

After you have the keys, you need to configure knife to connect to the right server

Create a file called `.chef/knife.rb`

```ruby
cwd                     = File.dirname(__FILE__)
log_level                :debug
log_location             STDOUT
node_name                "stackadmin"
client_key               "#{cwd}/stack.pem"
validation_client_name   "startupstack-validator"
validation_key           "#{cwd}/stack-validator.pem"
chef_server_url          "http://SERVER_ADDRESS/organizations/startupstack"
syntax_check_cache_path File.join(cwd,'syntax_check_cache')
cookbook_path           [File.join(cwd,'..','site-cookbooks'), File.join(cwd,'..','cookbooks')]
data_bag_path           File.join(cwd,'..','data_bags')
role_path               File.join(cwd,'..','roles')

cookbook_copyright "The Startup Stack"
cookbook_email "avi@avi.io"

knife[:use_sudo]              = true
knife[:dockerfiles_path]      = "#{cwd}/../dockerfiles"
knife[:aws_access_key_id]     = ENV.fetch('AWS_ACCESS_KEY_ID', '')
knife[:aws_secret_access_key] = ENV.fetch('AWS_SECRET_ACCESS_KEY', '')
```

Once you save this file, you should be good to go. You can validate with this command

`bin/knife client list`

If this commands exits with no errors, you are good to go.

### Production Use

In order to use chef in production it is best practice to create a signed SSL
certificate. This is a pretty easy process on basically every registerator.

Once you have your keys, it's 2 steps to install them and make chef use them.

Direct your DNS server to the chef server say `chef.the-startup-stack.com`

Download the `crt` and `key` file to the server

Lets say you downloaded them to this location:

```bash
/var/opt/opscode/nginx/ca/chef_the_startup_stack.crt
/var/opt/opscode/nginx/ca/chef_the_startup_stack.key
```

Edit `/etc/opscode/chef-server.rb` and put this content

Note: The file should be empty before you add something to it, no worries if
you don't see anything

```bash
nginx['ssl_certificate']  = "/var/opt/opscode/nginx/ca/chef_the_startup_stack.crt"
nginx['ssl_certificate_key']  = "/var/opt/opscode/nginx/ca/chef_the_startup_stack.key"
```

Once chef is done configuring, you should see a green sign on chrome saying the
certificate is configured properly

{% imgcap http://assets.avi.io/screen-shot-2015-07-26-mwkam.png %}
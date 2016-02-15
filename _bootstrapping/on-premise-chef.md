---
title: On Premise Chef
order: 1
show: false
prerequisites:
 - Amazon Keys /getting_started/02-keys-and-policies/
 - Chef Server SSL Certificate /bootstrapping/chef-server-certificate/
---

## On permise Installation

This installation will bootstrap chef server on amazon for you, as with (almost) everything, we will do it using terraform.

Export your keys into env variables

```bash
  $ export AWS_ACCESS_KEY=YOUR_KEY
  $ export AWS_SECRET_KEY=YOUR_SECRET
  $ export EC2_REGION=us-west-2
```

Head over to the [cookbook repo](https://github.com/the-startup-stack/stack-cookbooks),
clone it, then navigate into `terraform/chef`.

Chef server requires you to set some variables like username, password,
organization name and more.

In the `chef` directory thre's a `terraform.tfvars.example` file with all the
variables you need.

In order to provision the server execute the next steps

#### Copy the file in order to change content

```
cp terraform.tfvars.example terraform.tfvars
```

#### Change the data to fit your needs

```
chef_username = "stackadmin"
chef_user = "Stack Admin"
chef_password = "SomeVerySecurePassword"
chef_user_email = "ops@the-startup-stack.com"
chef_organization_id = "thestartupstack"
chef_organization_name = "The Startup Stack"
domain_name = "the-startup-stack.com"
```

After you have all the data correctly set up, you can continue

```bash
  $ export MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"`
  $ terraform get .
  $ terraform plan .
```

The first part of the command (`export MY_IP`) is making sure only your public IP
address will be able to ssh into the machine. This is best practice, never open SSH to the outside world.

This command will prompt all the variables needed in order to provision a chef
server successfully. When you are prompted to input your IP, you can simply use
$MY_IP you exported earlier.

<div class="alert alert-warning" role="alert">
  <h4>
    <strong>Heads Up!</strong> Before you continue applying the terraform config, make sure to look at userdata.sh in order to change the username/password settings to your preferred credentials.
    </h4>
</div>

Now that we see that the plan works, we can bootstrap out chef server.

```bash
$ terraform apply
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
chef_server_url
"http://chef.your-domain.com/organizations/your-organization-id"
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


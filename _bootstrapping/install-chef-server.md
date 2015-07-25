---
title: 01. Install Chef Server
order: 1
---

First thing you need in order to get started creating your stack is installing chef-server.

## Why

Chef server is a great way to centralize configuration across your cluster.
The startup stack uses data bags in order to store configuration, some secrets, keys, api keys and more.

## Control over your cluster

Chef server will save state of each of the nodes, allowing you to check out what's going on with each of the servers.

## Environment support

We use chef with Omni, which is a great way to support environments, you can push cookbooks changes to staging/dev without production being affected.

Once you tested and verified everything is working on the staging environment you can push the cookbook to staging and use knife to run chef-client on all the instances, distirbuting the configuration change in minutes across your cluster.

### Installation

As with everything, we will do it using terraform.

<div class="alert alert-info" role="alert">
  <h4>
    <strong>Heads Up</strong> Before we start, just make sure you created the KeyPair as described in <a href="/getting_started/02-get-your-keys-and-policies/">Getting Started/02-get-your-keys-and-policies</a>
    </h4>
</div>

Export your keys into env variables

```bash
export AWS_ACCESS_KEY=YOUR_KEY
export AWS_SECRET_KEY=YOUR_SECRET
export EC2_REGION=us-west-2
```

Head over to the [cookbook repo](https://github.com/the-startup-stack/stack-cookbooks), navigate into `terraform/chef`.

Now in order to make sure everything works. run this command 

This command is assuming they key name you created earlier is called `production`, if you named it something else, please change the name in the command.

The second part of the command is making sure only your public IP address will be able to ssh into the machine. This is best practice, never open SSH to the outside world.

```bash
export $MY_IP=`curl -s checkip.dyndns.org | sed -e "s/.*Current IP Address: //" -e "s/<.*$//"`
terraform plan -var key_name=production -var your_ip_address=$MY_IP
```

The output should be something like this:

```bash
+ aws_instance.web
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

Now that we see that the plan works, we can bootstrap out chef server.

```bash
terraform apply -var key_name=production -var your_ip_address=$MY_IP
```

This command will do the following

1. Create a security group and allow you to SSH into server from the IP address you are currently in.
2. Create the instance
3. Download chef server to the instance and install it.

Unfortunately, in order to finish the installation of the chef server, there are more manual actions needed, this is sub-optimal and definitely not something you will see often here but hey, you only do it once. :)





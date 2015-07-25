---
title: 02. Get Your Keys And Policies
order: 2
---

Once you have your account opened, entered your credit card and went through
the process of being verified on Amazon, you will need to get your access keys.

The AWS access keys are API keys that allow you to access all the services on
Amazon.  

{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-23-rx34o.png %}

## No Root Access by default

The recommendation is **not** to have a root access key, meaning you should not
create an access key for the admin user (you), alternatively, you need to
create an AIM user and use those access keys.

This is a best practive in order to manage access to resources better.


{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-23-wnhvv.png %}

Choose a name/names for your users

{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-23-nocw3.png %}

Get the keys

{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-23-e55wf.png %}

You can either copy pase or download a CSV and use it to store in a vault or
something like that.

## Secure your keys

Once the keys are created you **cannot** view them, download them or change
them, you can only create new keys, make sure you save those keys in a secure
place.

## Key Pair

Once you have your API credentials, you will also need your key pairs in order
to SSH into the machines for the first time.

Go here
[https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:sort=keyName](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:sort=keyName) and create your keys.

*this is assuming you are using `us-west-2` as the region*

I usually create multiple key pairs for environments and not a single one.

For example, right off the bat I usually start with 

* `production`
* `staging`
* `development`
* `test`

`test` is usually assigned to the CI servers or other machines that are running
test tasts. The rest are also pretty self explanatory

Now, create your key, say you create `production` first. Once you create it you will be able to download it.

I usually put my keys in the `~/.pem` directory.

So, you downloaded `production.pem.txt` to `~/Downloads` and now, lets move it to the right place.

```bash
cd ~/Downloads
mkdir ~/.pem
mv production.pem.txt ~/.pem/production.pem
chmod 600 ~/.pem/production.pem
```

The `chmod` part here is very important, if you don't do it, you will get a warning like `WARNING: UNPROTECTED PRIVATE KEY FILE!`.

## User Policy

In order for this user to be able to do anything on Amazon you will need to attach a policy.

When you navigate to the user, you will see a `User ARN` field

{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-24-lzip3.png %}

Copy this value and make sure you have it, since we'll need it for the next stage

Now, scroll down to attach inline policies

{% imgcap http://aviioblog.s3.amazonaws.com/screen-shot-2015-07-24-3ygy2.png %}

Go through the custom policy.

Select policy name `FullAccess` and give this Document

```javascript
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "YOUR_USER_ID"
        }
    ]
}
```

`YOUR_USER_ID` being the id you copied in the previous stage.

Hit `Validate Policy` to make sure everytihng works and apply it.

<div class="alert alert-warning" role="alert">
  <h4>
    <strong>Heads Up</strong> This policy has access to everything. It's great when you get started and you are the only one managing your cluster, in the future, make sure to have more fine grained policies
    </h4>
</div>
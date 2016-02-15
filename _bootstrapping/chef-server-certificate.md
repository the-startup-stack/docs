---
title: Chef Server Certificate
order: 1
show: false
---

## Chef Server SSL certificate

Chef server requires an SSL certificate in order to make sure you can query
the server with no problems.

Regardless of who's your DNS provider, you will need 2 files

1. pem file (private key)
2. Signing key

When you'll try to provision the chef server using terraform, it will ask for
the file names. You must have those files readily available in order to make
sure chef server is bootstrapped correctly.

**DO NOT** check in those files to source control

## Verification

Once chef is done configuring, you should see a green sign on chrome saying the
certificate is configured properly

{% imgcap http://assets.avi.io/screen-shot-2015-07-26-mwkam.png %}

---
title: 03. Install Terraform
order: 3
---

{% imgcap /img/getting_started/terraform.png 150 150 Terraform %}

Terraform is being used to launch the initial cluster, descirbe security groups and more.

Terraform is absolutely essential in order to manage a cluster of this size, knowing the security groups, making sure all the ports are open when you need them and other useful tasks.

### Installing on a mac

If you are using a Mac, you can use homebrew to install it.

```bash
  brew install terraform
```

### Installing on other platforms

If you are using any other platorm, just head over to the releases page on
Github and grab your executable.
[https://github.com/hashicorp/terraform/releases](https://github.com/hashicorp/terraform/releases)


Once you have it installed, we can start really working with our cluster.
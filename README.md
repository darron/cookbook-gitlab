# gitlab cookbook

This [Chef](http://www.opscode.com/chef/) cookbook and [Capistrano](https://github.com/capistrano/capistrano) recipe is created to:

1. Setup an Ubuntu 12.0.4 server to be ready for [GitlabHQ](https://github.com/gitlabhq/gitlabhq)
2. Push the [4.0-stable branch](https://github.com/gitlabhq/gitlabhq/tree/4-0-stable) of Gitlab

I've separated it into two components because:

1. I wanted to better understand the [setup process](https://github.com/gitlabhq/gitlab-recipes/tree/master/install/v4) from start to finish and build an idempotent Chef cookbook.
2. I like the ability to push new releases using Capistrano.

# Requirements

Tested on Ubuntu 12.0.4 using:

1. [Vagrant](http://www.vagrantup.com)
2. [Rackspace Cloud](http://www.rackspace.com/cloud/)

You need to have Ruby 1.9.3-p327, Bundler and Chef already installed - [I have included my Ubuntu 12.0.4LTS bootstrap](https://github.com/darron/cookbook-gitlab/blob/master/config/bootstrap.rb).

There's a Vagrant test vm available [here](https://dl.dropbox.com/u/695019/vagrant/precise-193p327.box).

# Usage

1. Add your own ssh public keys to `templates/default/gitlab_authorized_keys.erb`
2. Add `recipe[gitlab]` to your node's runlist - run: `chef-client`
3. Edit `:domain` in `config/deploy.rb` and then: `cap deploy` (It may fail to "restart" at the end - that's OK.)
4. Edit `/home/gitlab/.pam_environment` - that's where the database username / passsword are kept.
5. `cap deploy:app_setup`
6. `cap deploy:start`
7. Browse to the ip address and sign in as the default user. (admin@local.host / 5iveL!fe) NOTE: You may need to give it a second to compile all of the assets and get spun up properly - if you see an Nginx 502 Gateway error give it a second.
8. Profit

# Attributes

# Recipes

# Author

Author:: Darron Froese (<darron@froese.org>)

# nîso ᓃᓱ

    niso is the number 2 (two) in Cree

### Requirements

### What's new:

Please see the [CHANGELOG](https://github.com/dakotalightning/sunzi/blob/master/CHANGELOG.md).

## Quickstart

Install:

  $ [sudo] gem install niso

Go into your project directory (if it's a Rails project, `config` would be a good place to start with), then:

  $ niso create

It generates a `niso` folder along with subdirectories and templates. Inside `niso`, there are `niso.yml` and `install.sh`. Those two are the most important files that you mainly work on.

Go into the `sunzi` directory, then run `niso deploy`:

  $ cd niso
  $ niso deploy example.com

Now, what it actually does is:

1. Compile `niso.yml` to generate attributes and retrieve remote recipes, then copy files into the `compiled` directory
1. SSH to `example.com` and login as `root`
1. Transfer the content of the `compiled` directory to the remote server and extract in `$HOME/niso`
1. Run `install.sh` on the remote server

As you can see, all you need to do is edit `install.sh` and add some shell commands. That's it.

A Sunzi project without any recipes or roles is totally fine, so that you can start small, go big as you get along.

## Commands

  $ niso                                           # Show command help
  $ niso compile                                   # Compile niso project
  $ niso create                                    # Create a new niso project
  $ niso deploy [user@host:port] [role] [--sudo]   # Deploy niso project

  $ niso setup                                     # Setup a new digital ocean droplet
  $ niso teardown                                  # Teardown an existing digital ocean droplet

## Directory structure

Here's the directory structure that `niso create` automatically generates:

  niso/
    install.sh      # main script
    niso.yml        # add custom attributes and remote recipes here

    recipes/        # put commonly used scripts here, referred from install.sh
      niso.sh
    roles/          # when role is specified, scripts here will be concatenated
      db.sh         # to install.sh in the compile phase
      web.sh
    files/          # put any files to be transferred
    compiled/       # everything under this folder will be transferred to the
                    # remote server (do not edit directly)

## How do you pass dynamic values?

There are two ways to pass dynamic values to the script - ruby and bash.

**For ruby (recommended)**: Make sure `eval_erb: true` is set in `sunzi.yml`. In the compile phase, attributes defined in `sunzi.yml` are accessible from any files in the form of `<%= @attributes.ruby_version %>`.

**For bash**: In the compile phase, attributes defined in `sunzi.yml` are split into multiple files in `compiled/attributes`, one per attribute. Now you can refer to it by `$(cat attributes/ruby_version)` in the script.

For instance, given the following `install.sh`:

  echo "Goodbye <%= @attributes.goodbye %>, Hello <%= @attributes.hello %>!"

With `niso.yml`:

  attributes:
    goodbye: Chef
    hello: niso

Now, you get the following result.

  Goodbye Chef, Hello niso!

## Remote Recipes

Recipes can be retrieved remotely via HTTP. Put a URL in the recipes section of `niso.yml`, and Sunzi will automatically load the content and put it into the `compiled/recipes` folder in the compile phase.

For instance, if you have the following line in `niso.yml`,

  recipes:
    rvm: https://raw.github.com/kenn/sunzi-recipes/master/ruby/rvm.sh

`rvm.sh` will be available and you can refer to that recipe by `source recipes/rvm.sh`.

You may find sample recipes in this repository useful: https://github.com/kenn/sunzi-recipes

## Role-based configuration

You probably have different configurations between **web servers** and **database servers**.

No problem - how Sunzi handles role-based configuration is refreshingly simple.

Shell scripts under the `roles` directory, such as `web.sh` or `db.sh`, are automatically recognized as a role. The role script will be appended to `install.sh` at deploy, so you should put common configurations in `install.sh` and role specific procedures in the role script.

For instance, when you set up a new web server, deploy with a role name:

  niso deploy example.com web

It is equivalent to running `install.sh`, followed by `web.sh`.

## Cloud Support

### DigitalOcean
You can setup a new VM, or teardown an existing VM interactively. Use `sunzi setup` and `sunzi teardown` for that.

[DigitalOcean](https://www.digitalocean.com) only.

v2.0 of the DigitalOcean API is supported &mdash; get your API key and client key [here](https://cloud.digitalocean.com/api_access).

## Credits

- This project is a hard fork of the proejct [sunzi](https://github.com/kenn/sunzi) by [kenn](https://github.com/kenn).

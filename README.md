# nîso ᓃᓱ

[![Gem Version](https://badge.fury.io/rb/niso.svg)](https://badge.fury.io/rb/niso) [![Build Status](https://travis-ci.org/dakotalightning/niso.svg?branch=master)](https://travis-ci.org/dakotalightning/niso)

    niso is the number 2 (two) in Cree

## Quickstart

Example: https://github.com/dakotalightning/niso-example

Install:

    $ [sudo] gem install niso

Go into your project directory (if it's a Rails project, `config` would be a good place to start with), then:

    $ niso create

It generates a `niso` folder along with subdirectories and templates. Inside `niso`, there are `niso.yml` and `install.sh`. Those two are the most important files that you mainly work on.

Go into the `niso` directory, then run `niso deploy`:

    $ cd niso
    $ niso deploy example.com

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

## Dynamic values?

There are two ways to pass dynamic values to the script - ruby and bash.

Make sure `eval_erb: true` is set in `niso.yml`. In the compile phase, attributes defined in `niso.yml` are accessible from any files in the form of `<%= @attributes.ruby_version %>`.

## Role-based configuration

You probably have different configurations between **web servers** and **database servers**.

No problem - how niso handles role-based configuration is refreshingly simple.

Shell scripts under the `roles` directory, such as `web.sh` or `db.sh`, are automatically recognized as a role. The role script will be appended to `install.sh` at deploy, so you should put common configurations in `install.sh` and role specific procedures in the role script.

For instance, when you set up a new web server, deploy with a role name:

    niso deploy example.com web

It is equivalent to running `install.sh`, followed by `web.sh`.

## Requirements

For `niso deploy`

    $ [sudo] gem install droplet_kit
    $ [sudo] gem install highline

## DigitalOcean
You can setup a new VM, or teardown an existing VM interactively. Use `niso setup` and `niso teardown` for that.

[DigitalOcean](https://www.digitalocean.com) only.

v2.0 of the DigitalOcean API is supported &mdash; get your [access token](https://cloud.digitalocean.com/api_access).

## Changelong:

Please see the [CHANGELOG](https://github.com/dakotalightning/niso/blob/master/CHANGELOG.md).

## Contributing

1. Fork the project
2. Make your changes, including tests that exercise the code
3. Summarize your changes in [CHANGELOG](https://github.com/dakotalightning/niso/blob/master/CHANGELOG.md)
4. Make a pull request

## Credits

- This project is a hard fork of the proejct [niso](https://github.com/kenn/niso) by [kenn](https://github.com/kenn).

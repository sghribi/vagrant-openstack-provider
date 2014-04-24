# Vagrant Openstack Cloud Provider

[![Build Status](https://api.travis-ci.org/ggiamarchi/vagrant-openstack.png?branch=master)](http://travis-ci.org/ggiamarchi/vagrant-openstack)
[![Dependencies Status](https://gemnasium.com/ggiamarchi/vagrant-openstack.png)](http://gemnasium.com/ggiamarchi/vagrant-openstack)
[![Code Climate](https://codeclimate.com/github/ggiamarchi/vagrant-openstack.png)](https://codeclimate.com/github/ggiamarchi/vagrant-openstack)

This is a [Vagrant](http://www.vagrantup.com) 1.1+ plugin that adds a
[Openstack Cloud](http://www.openstack.com/cloud) provider to Vagrant,
allowing Vagrant to control and provision machines within Openstack
cloud.

**Note:** This plugin requires Vagrant 1.1+.

## Features

* Boot Openstack Cloud instances.
* SSH into the instances.
* Provision the instances with any built-in Vagrant provisioner.
* Minimal synced folder support via `rsync`.

## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After
installing, `vagrant up` and specify the `openstack` provider. An example is
shown below.

```
$ vagrant plugin install vagrant-openstack
...
$ vagrant up --provider=openstack
...
```

Of course prior to doing this, you'll need to obtain an Openstack-compatible
box file for Vagrant.

### CentOS / RHEL (sudo: sorry, you must have a tty to run sudo)

The default configuration of the RHEL family of Linux distributions requires a tty in order to run sudo.  Vagrant does not connect with a tty by default, so you may experience the error:
> sudo: sorry, you must have a tty to run sudo

The best way to take deal with this error is to upgrade to Vagrant 1.4 or later, and enable:
```
config.ssh.pty = true
```

## Quick Start

After installing the plugin (instructions above), the quickest way to get
started is to actually use a dummy Openstack box and specify all the details
manually within a `config.vm.provider` block. So first, add the dummy
box using any name you want:

```
$ vagrant box add dummy https://github.com/ggiamarchi/vagrant-openstack/raw/master/dummy.box
...
```

And then make a Vagrantfile that looks like the following, filling in
your information where necessary.

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :openstack do |rs|
    rs.username = "YOUR USERNAME"
    rs.api_key  = "YOUR API KEY"
    rs.flavor   = /1 GB Performance/
    rs.image    = /Ubuntu/
    rs.metadata = {"key" => "value"}       # optional
  end
end
```

And then run `vagrant up --provider=openstack`.

This will start an Ubuntu 12.04 instance in the DFW datacenter region within
your account. And assuming your SSH information was filled in properly
within your Vagrantfile, SSH and provisioning will work as well.

Note that normally a lot of this boilerplate is encoded within the box
file, but the box file used for the quick start, the "dummy" box, has
no preconfigured defaults.

## Box Format

Every provider in Vagrant must introduce a custom box format. This
provider introduces `openstack` boxes. You can view an example box in
the [example_box/ directory](https://github.com/ggiamarchi/vagrant-openstack/tree/master/example_box).
That directory also contains instructions on how to build a box.

The box format is basically just the required `metadata.json` file
along with a `Vagrantfile` that does default settings for the
provider-specific configuration for this provider.

## Configuration

This provider exposes quite a few provider-specific configuration options:

* `api_key` - The API key for accessing Openstack.
* `flavor` - The server flavor to boot. This can be a string matching
  the exact ID or name of the server, or this can be a regular expression
  to partially match some server flavor. Flavors are listed [here](#flavors).
* `image` - The server image to boot. This can be a string matching the
  exact ID or name of the image, or this can be a regular expression to
  partially match some image.
* `openstack_region` - The region to hit. By default this is :dfw. Valid options are: 
:dfw, :ord, :lon, :iad, :syd.  Users should preference using this setting over `openstack_compute_url` setting.
* `openstack_compute_url` - The compute_url to hit. This is good for custom endpoints. 
* `openstack_auth_url` - The endpoint to authentication against. By default, vagrant will use the global
openstack authentication endpoint for all regions with the exception of :lon. IF :lon region is specified
vagrant will authenticate against the UK authentication endpoint.
* `public_key_path` - The path to a public key to initialize with the remote
  server. This should be the matching pair for the private key configured
  with `config.ssh.private_key_path` on Vagrant.
* `key_name` - If a public key has been [uploaded to the account already](http://docs.openstack.com/servers/api/v2/cs-devguide/content/ServersKeyPairs-d1e2545.html), the uploaded key can be used to initialize the remote server by providing its name.  The uploaded public key should be the matching pair for the private key configured
  with `config.ssh.private_key_path` on Vagrant.
* `server_name` - The name of the server within Openstack Cloud. This
  defaults to the name of the Vagrant machine (via `config.vm.define`), but
  can be overridden with this.
* `username` - The username with which to access Openstack.
* `disk_config` - Disk Configuration  'AUTO' or 'MANUAL'
* `metadata` - A set of key pair values that will be passed to the instance
  for configuration.

These can be set like typical provider-specific configuration:

```ruby
Vagrant.configure("2") do |config|
  # ... other stuff

  config.vm.provider :openstack do |rs|
    rs.username = "mitchellh"
    rs.api_key  = "foobarbaz"
  end
end
```

## Networks

Networking features in the form of `config.vm.network` are not
supported with `vagrant-openstack`, currently. If any of these are
specified, Vagrant will emit a warning, but will otherwise boot
the Openstack server.

However, you may attach a VM to an isolated [Cloud Network](http://www.openstack.com/knowledge_center/article/getting-started-with-cloud-networks) (or Networks) using the `network` configuration option. Here's an example which adds two Cloud Networks and disables ServiceNet with the `:attach => false` option:

```ruby
config.vm.provider :openstack do |rs|
  rs.username = "mitchellh"
  rs.api_key  = "foobarbaz"
  rs.network '443aff42-be57-effb-ad30-c097c1e4503f'
  rs.network '5e738e11-def2-4a75-ad1e-05bbe3b49efe'
  rs.network :service_net, :attached => false
end
```

## Synced Folders

There is minimal support for synced folders. Upon `vagrant up`,
`vagrant reload`, and `vagrant provision`, the Openstack provider will use
`rsync` (if available) to uni-directionally sync the folder to
the remote machine over SSH.

This is good enough for all built-in Vagrant provisioners (shell,
chef, and puppet) to work!

## Development

To work on the `vagrant-openstack` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

Once you have the dependencies, verify the unit tests pass with `rake`:

```
$ bundle exec rake
```

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
that uses it, and uses bundler to execute Vagrant:

```
$ bundle exec vagrant up --provider=openstack
```
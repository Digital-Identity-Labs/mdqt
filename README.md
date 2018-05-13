# MDQT - A Metadata Query Tool

[![Gem Version](https://badge.fury.io/rb/mdqt.svg)](https://badge.fury.io/rb/mdqt) [![Maintainability](https://api.codeclimate.com/v1/badges/111c46aaebfe25e4a4a9/maintainability)](https://codeclimate.com/github/Digital-Identity-Labs/mdqt/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/111c46aaebfe25e4a4a9/test_coverage)](https://codeclimate.com/github/Digital-Identity-Labs/mdqt/test_coverage) [![Build Status](https://travis-ci.org/Digital-Identity-Labs/mdqt.svg?branch=master)](https://travis-ci.org/Digital-Identity-Labs/mdqt)

MDQT is small library and commandline tool to query MDQ services for SAML metadata.
You could do this with `curl` and `xmlsec1` but it's a little more convenient to use `mdqt` instead.

MDQ currently supports:

  - Downloading single entities, lists or aggregates
  - Signature verification
  - Saving metadata to disk
  - Caching entity metadata on disk
  - Gzip compression

## MDQ?

MDQ is a simple HTTP-based standard for looking up individual SAML entity metadata. Rather than regularly
downloading large metadata aggregates containing thousands of entity descriptions,
an IdP or SP can download the metadata for an individual entity whenever it is needed.

The UK Access Management Federation has a
[useful page explaining MDQ](https://www.ukfederation.org.uk/content/Documents/MDQ)

## Installation

MDQT is tested on recent MacOS and Linux, and should work with
 Ruby 2.1.0 or later and recent JRuby releases.

### As a gem for general use

To install system-wide on your default Ruby, use

    $ sudo gem install mdqt

If using a per-user Ruby via `rbenv` or similar, you'll just need

    $ gem install mdqt

### As part of a Ruby project

To add MDQT to a Ruby project include this line in your application's `Gemfile`

```ruby
gem 'mdqt'
```

and then execute:

    $ bundle

### Extra steps for verifying signed metadata

MDQT can check that metadata has not been tampered with by verifying its
signature. Some MDQ services use unencrypted HTTP connections and rely
 on signed metadata.

MDQT supports signature verification but requires a Ruby library called
Nokogiri to do the hard work. Nokogiri is fast and useful but can sometimes
be awkward to install for non-developers (it requires a C development
environment and various XML libraries). To make it easier to install a basic MDQT we've made
XML signature verification an optional feature.

To enable signature verification you must also install the `xmdsig` gem:

    $ sudo gem install xmldsig

The `xmldsig` gem will install Nokogiri, and Nokogiri will try to build itself.
If you encounter any problems installing Nokogiri the
[Installing Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html)
documentation is very helpful.

## Commandline Usage as an MDQ client

You can see a list of commandline options by typing:

    $ mdqt help

To see more information about a command, use the `--help` option after the command or type `help <command>`:

    $ mdqt help get

### Selecting an MDQ service to access

You can specify the MDQ service with a commandline option:

    $ mdqt get --service https://mdq.example.com/mdq  http://entity.ac.uk/shibboleth

It's more convenient to set an environment variable to specify a default MDQ
service. Set `MDQT_SERVICE` or `MDQ_BASE_URL` to the base URL of your MDQ service.

    $ export MDQT_SERVICE=https://mdq.example.com/mdq
    $ mdqt get http://entity.ac.uk/shibboleth
    $ mdqt get http://example.org/service

Finally, if you don't specify an MDQ service with `--service` or `MDQT_SERVICE` then `mdqt` *might* be
able to guess your local NREN's MDQ service. Do not do this in production!

### Downloading entity metadata

Downloading entity metadata to STDOUT:

    $ mdqt get https://test-idp.ukfederation.org.uk/idp/shibboleth

Using the sha1 hashed version of entity IDs requires quotes or escaping in some shells:

    $ mdqt get "{sha1}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9"

    $ mdqt get \{sha1\}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9

Requesting all metadata from an MDQ endpoint is done by specifying `--all`:

    $ mdqt get --all


### Caching metadata

Caching can be enabled using `--cache`. At the moment the `mdqt` executable
only supports caching to disk. It will create a cache directory in your temporary
directory.

    $ mdqt get --cache --service https://mdq.example.com/mdq http://entity.ac.uk/shibboleth

You can clear the cache by using the `reset` command:

    $ mdqt reset


### Verifying metadata

If you have enabled verification by installing `xmldsig` (and have downloaded and checked a suitable
certificate for your MDQ server) you can require verification by passing
they `verify-with` flag with the path of your certificate.

    $ mdqt get --verify-with myfederation.pem https://indiid.net/idp/shibboleth

It's possible to pass more than one certificate by separating them with commas

    $ mdqt get --verify-with myfederation.pem,previous.pem https://indiid.net/idp/shibboleth

### Saving metadata as files

The simplest way to save metadata is to redirect output from the `get` command:

    $ mdqt get http://entity.ac.uk/shibboleth > metadata.xml

MDQT also offers the `--save-to` option to write all metadata into a directory

    $ mdqt get http://entity.ac.uk/shibboleth --save-to metadata_directory

The  `--save-to` option requires a directory to be specified. All files will be saved
with a name based on their transformed identifier (sha1 hash) such as
`77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`

By adding the `--link-id' flag alternative filenames will be linked to the
original file (this is currently a little experimental) to make it easier
to look up the correct file using other identifiers.

### Other features

For more information about current settings, download results, and so on, add
`--verbose` to commands.

    $mdqt get --verbose http://entity.ac.uk/shibboleth

To convert normal URI entity IDs into MDQ SHA1 hashed transformed identifiers just use the `transform` command:

    $ mdqt transform http://example.org/service

Transforming identifiers that have already been transformed should not re-transform them.

To see more details of what is being sent and received by a `get` command add the `--explain` flag

    $ mdqt get --explain --service https://mdq.example.com/mdq  http://entity.ac.uk/shibboleth

MDQT will then show a table of sent and recieved headers which may be useful when debugging servers.

## Library Usage

Please don't! This gem is very early in development and the API is not stable. Later
releases of this gem will provide a simple library to use in other Ruby applications.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Digital-Identity-Labs/mdqt.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

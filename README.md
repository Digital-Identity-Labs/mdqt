# MDQT - A Metadata Query Tool

[![Gem Version](https://badge.fury.io/rb/mdqt.svg)](https://badge.fury.io/rb/mdqt) [![Maintainability](https://api.codeclimate.com/v1/badges/111c46aaebfe25e4a4a9/maintainability)](https://codeclimate.com/github/Digital-Identity-Labs/mdqt/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/111c46aaebfe25e4a4a9/test_coverage)](https://codeclimate.com/github/Digital-Identity-Labs/mdqt/test_coverage) [![Build Status](https://travis-ci.org/Digital-Identity-Labs/mdqt.svg?branch=master)](https://travis-ci.org/Digital-Identity-Labs/mdqt)

MDQT is small library and commandline tool to query MDQ services for SAML metadata.
You could do this with `curl` and `xmlsec1` but it's a little more convenient to use `mdqt` instead.

MDQT also has features for managing local metadata files, to help when running an MDQ service or a Shibboleth IdP or SP.

MDQ currently provides these features:

  - Downloading single entities, lists or aggregates
  - Signature verification
  - Validating metadata against SAML2 schema
  - Saving metadata to disk
  - Extracting entity IDs from both aggregate and individual metadata files
  - Renaming metadata files to their entity ID sha1 hashes (for use with LocalDynamicMetadataProvider)
  - Creating sha1 hash symlinks to metadata files (also for use with Local Dynamic Metadata)
  - Listing the entity IDs of downloaded metadata files
  - Showing the full URL of an entity
  - Caching entity metadata and using Gzip compression


## MDQ?

MDQ is a simple HTTP-based standard for looking up individual SAML entity metadata. Rather than regularly
downloading large metadata aggregates containing thousands of entity descriptions,
an IdP or SP can download the metadata for an individual entity whenever it is needed.

The UK Access Management Federation has a
[useful page explaining MDQ](https://www.ukfederation.org.uk/content/Documents/MDQ)

## Installation

MDQT is tested on recent MacOS and Linux, and should work with
 Ruby 3.0.0 or later and recent JRuby releases.

### As a gem for general use

To install system-wide on your default Ruby, use

    $ sudo gem install mdqt

If using a per-user Ruby via `rbenv`, `asdf` or similar, you'll need

    $ gem install mdqt

### As part of a Ruby project

To add MDQT to a Ruby project include this line in your application's `Gemfile`

```ruby
gem 'mdqt'
```

and then execute:

    $ bundle

### As a Docker container

(Experimental)
See the instructions at [MDQT-Container](https://github.com/Digital-Identity-Labs/mdqt-container)

### Verifying signed metadata, installing Nokogiri

MDQT can check that metadata has not been tampered with by verifying its
signature. Some MDQ services use unencrypted HTTP connections and rely
 on signed metadata.

MDQT supports signature verification but requires a Ruby library called
Nokogiri to do the hard work. Nokogiri is fast and useful but can sometimes
be awkward to install for non-developers (it can sometimes require a C development
environment and various XML libraries). In most cases Nokogiri will install 
automatically, without problems, when you install MDQT, but if you encounter any 
problems installing Nokogiri the [Installing Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html) documentation is very helpful.

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

If an MDQ service is known to MDQT it can be selected using an alias:

    $ mdqt get --service incommon  http://entity.edu/shibboleth

You can see known services and their aliases using `mdqt services`

### Downloading entity metadata

Downloading entity metadata to STDOUT:

    $ mdqt get https://test-idp.ukfederation.org.uk/idp/shibboleth

Using the sha1 hashed version of entity IDs requires quotes or escaping in some shells:

    $ mdqt get "{sha1}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9"

    $ mdqt get \{sha1\}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9

    $ mdqt get [sha1]52e2065fc0d53744e8d4ee2c2f30696ebfc5def9

Requesting all metadata from an MDQ endpoint is done by specifying `--all`:

    $ mdqt get --all


### Caching metadata

Caching can be enabled using `--cache`. At the moment the `mdqt` executable
only supports caching to disk. It will create a cache directory in your temporary
directory.

    $ mdqt get --cache --service https://mdq.example.com/mdq http://entity.ac.uk/shibboleth

Caching is now on by default. To force a single command to *not* use the cache, include `--reset`

    $ mdqt get --reset --service https://mdq.example.com/mdq http://entity.ac.uk/shibboleth

You can clear the cache by using the `reset` command:

    $ mdqt reset


### Verifying metadata

If you have enabled verification by installing `xmldsig` (and have downloaded and checked a suitable
certificate for your MDQ server) you can require verification by passing
they `verify-with` flag with the path of your certificate.

    $ mdqt get --verify-with myfederation.pem https://indiid.net/idp/shibboleth

It's possible to pass more than one certificate by separating them with commas

    $ mdqt get --verify-with myfederation.pem,previous.pem https://indiid.net/idp/shibboleth

Basic XML correctness and validation against SAML2 Metadata schema can be enabled with the
`--validate` switch:

    $ mdqt get --validate https://indiid.net/idp/shibboleth

If you need to check metadata that has already been downloaded then try the `check`
command:

    $ mdqt check metadata.xml # Just validate
    $ mdqt check --verify-with myfederation.pem metadata.xml # Verify signature too

You shouldn't need to *validate* XML from a trusted MDQ service such as one run by a
national federation. You should however always *verify* the signature of XML sent over an unencrypyted HTTP connection,
and probably even over HTTPS. MDQT's validation check is mostly for use when writing
or debugging your own MDQ service.

### Saving metadata as files

The simplest way to save metadata is to redirect output from the `get` command:

    $ mdqt get http://entity.ac.uk/shibboleth > metadata.xml

MDQT also offers the `--save-to` option to write all metadata into a directory

    $ mdqt get http://entity.ac.uk/shibboleth --save-to metadata_directory

The `--save-to` option requires a directory to be specified. All files will be saved
with a name based on their transformed identifier (sha1 hash) such as
`77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`

### Other Features

For more information about current settings, download results, and so on, add
`--verbose` to commands:

    $mdqt get --verbose http://entity.ac.uk/shibboleth

To convert normal URI entity IDs into MDQ SHA1 hashed transformed identifiers use the `transform` command:

    $ mdqt transform http://example.org/service

Transforming identifiers that have already been transformed should not re-transform them.

To see more details of what is being sent and received by a `get` command add the `--explain` flag

    $ mdqt get --explain --service https://mdq.example.com/mdq  http://entity.ac.uk/shibboleth

MDQT will then show a table of sent and received headers which may be useful when debugging servers.

To extract a list of all entity IDs from a file:

    $ mdqt entities metadata.xml

    $ mdqt entities --sha1 metadata.xml

To create sha1 symlinks to a metadata file:

    $ mdqt ln example_idp.xml

To rename a file to its entity ID sha1 has:

    $ mdqt rename example_idp.xml

To list the entity IDs of files in a directory:

    $ mdqt ls

To list all entities available at an MDQ service:

    $ mdqt list

To show the MDQ services known to MDQT, and their aliases:

    $ mdqt services

To show the full MDQ URL of an entity

    $ mdqt url http://entity.ac.uk/shibboleth

MDQT can accept input on stdin, allowing composition and pipelining

    $ cat list_of_ids.txt | mdqt url

    $ mdqt list | grep cern.ch | mdqt get --save-to cern_metadata/ --list  | mdqt ls

## Alternatives

  * [SAML Library](https://github.com/trscavo/saml-library) is a set of scripts to help with metadata-related tasks, written
by Tom Scavo of Internet2. Some of the scripts provide similar functionality to MDQT, and are designed to be piped together.

## Library Usage

Please don't! We originally had plans to include a usable generic library was part of MDQT but unless there's new demand
for it that's now unlikely to happen. However, we do now have a set of libraries for the Elixir language, based around
[Smee](https://github.com/Digital-Identity-Labs/smee) - not very helpful for Ruby projects but possibly of use for new
projects.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Digital-Identity-Labs/mdqt.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

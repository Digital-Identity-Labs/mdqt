# MDQT - A Metadata Query Tool

MDQT is small library and commandline tool to query MDQ services for SAML metadata.
You can do this with `curl` but it's a little more convenient to use `mdqt` instead.

At present `mdqt` does *not* verify signed metadata, so an extra step is required to use it
securely.

## MDQ?

MDQ is a simple HTTP-based standard for looking up individual SAML entity metadata. Rather than regularly
downloading large metadata aggregates containing thousands of entity descriptions,
an IdP or SP can download the metadata for individual entities using MDQ when they are needed.

The UK Access Management Federation has a
[useful page explaining MDQ](https://www.ukfederation.org.uk/content/Documents/MDQ)

## Installation

To add mdqt to a project, add this line to your application's Gemfile

```ruby
gem 'mdqt'
```

and then execute:

    $ bundle

To install system-wide on your default Ruby, use

    $ sudo gem install mdqt

If using a per-user Ruby such via `rbenv` or similar, you'll just need

    $ gem install mdqt

## Commandline Usage as an MDQ client

You can see a list of commandline options by typing

    $ mdqt --help

Specifying the MDQ service with a commandline option

    $ mdqt get --service https://mdq.example.com/mdq  http://entity.ac.uk/shibboleth

It's more convenient to set an environment variable to specify a default MDQ
service. Set MDQT_SERVICE or MDQ_BASE_URL to the base URL of your MDQ service.

Downloading entity metadata to STDOUT

    $ mdqt get https://test-idp.ukfederation.org.uk/idp/shibboleth

Using sha1 hashed version of entity IDs requires quotes or escaping

    $ mdqt get "{sha1}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9"

    $ mdqt get \{sha1\}52e2065fc0d53744e8d4ee2c2f30696ebfc5def9

Requesting all metadata from an MDQ endpoint is done by specifying `--all`

    $ mdqt get --all


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

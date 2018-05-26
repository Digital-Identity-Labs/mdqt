# Changelog

## 0.4.0

### New Features
- The `check` command will validate XML files against SAML metadata schema and verify signatures
- A `--validate` switch for `get` forces XML validation, using basic SAML2 metadata schema
- A `--tls-risky` switch for `get` disables verification of TLS certificates

### Improvements
- Connection failures now show an explanation (such as TLS problems)

### Fixes
- "Not Required" was shown when using commands that don't interact with an MDQ server

## 0.3.1

### Fixes
- A missing xmldsig gem is now handled properly *everywhere*. Hopefully.

## 0.3.0

### New Features
- Signature verification (at last!) using `--verify-with` option for get command
- A `reset` command to clear all cached metadata
- A `transform` command to convert entityID URIs to {sha1} identifiers
- The `--explain` option for `get` will show header information
- The `--save-to` option for `get` will write metadata to disk
- The `--link-id` option for `get --save-to` will create aliases

### Improvements
- Coloured feedback
- Improved README documentation
- Servers' 304 responses for cached files are handled correctly
- Invalid SHA1 transformed identitifiers can't be sent
- 500 errors at the server will be shown correctly
- Verbose mode shows MDQT version

### Fixes
- Don't show empty identifier in OK message after downloading aggregate
- Cache status in introduction text is now correct

## 0.2.1

### Fixes
- Send Accept header rather than Content-Type header 🙄

## 0.2.0

### New Features
- Option to cache HTTP requests to the MDQ service
- Supports Gzip compression by default
- Default MDQ service selection (rather crude, maybe not a good idea at all)

### Improvements
- Supports redirect responses
- Helpful error messages and status messages
- Verbose mode will show successful connection information
- Warnings about unspecified MDQ service
- Catch bad URLs for the MDQ service and fail with a better error message

### Fixes
- Aggregates are now requested with /entities not /entities/, as per spec

### Other
- First few Cucumber features to define and test the executable
- Beginning of an RSpec suit to define the API
- Minimum version of Ruby is now 2.1, but only 2.2+ is tested using CI

## 0.1.1

### Fixes
- Bug that prevented the mdqt executable from running outside a Bundler environment

## 0.1.0

- Initial release
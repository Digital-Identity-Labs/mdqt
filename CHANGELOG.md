# Changelog

## 0.8.0

## Breaking Changes

- MDQT now requires Ruby 3.0 or later, due to updated dependencies and their requirements
- MDQT now installs XML handling gems automatically - Nokogiri and XMLDSig are no longer optional. Nokogiri seems to be
  less troublesome to install now and is needed by some useful current and planned features. Please let me know if this
  causes you any problems.

## Improvements

- New HTTP library means caching should be slightly faster and HTTP2 is now supported
- MDQ base URLs should end with a slash, so slashless URLs are now normalised to include one.

## Fixes

- URLs for MDQ entity records now properly support paths - previously only MDQ services at the root path would work

## 0.7.0

### Improvements

- `mdqt check` can now (I think) cope with SAML metadata from Microsoft AD/ADFS services full of WS-* extensions.
- Tested with Ruby 3.2.0: `File.exists?` has been removed from 3.2.0 (it's been deprecated for years and I used it out of habit) 
  so this has been replaced in MDQT with `File.exist?` - as a result Ruby 3.2.0 onwards will work, but Ruby older than v2.2
  will no longer work.

### Fixes

- The inline help synopsis for `mdqt check` has been corrected.

### Known issues

- Running mdqt without STDIN available (outside of a normal shell environment) can cause it to freeze unless 
  `export MDQT_STDIN=off` is set. See [Issue 8](https://github.com/Digital-Identity-Labs/mdqt/issues/8)
- Checking signatures on very large aggregate XML files can sometimes fail on M1/M2 MacOS and trying to work out why 
  has made me slightly balder and a lot more puzzled. See [Issue 9](https://github.com/Digital-Identity-Labs/mdqt/issues/9) 

## 0.6.0

### New Features

- STDIN and pipes: Arguments (such as filenames and entity IDs) can now be piped into mdqt. This 
  enables pipelining, so you can chain commands together.
- The `rename` command now has a `--link` option that creates a symlink from the original
  filename to the renamed file.
- The `get` command now has a `--list` option that works when `--save-to` is used, to list filenames being
  written to disk. 

### Improvements

- Emacs backup files (so called turd files) ending with ~ and files ending with .bak 
  are now ignored.

### Removed features

- `link` and `rename` now require files to be specified: you now *cannot* run `mdqt rename`
  to rename everything in the current directory.

- The `--link_id` option for `get` saved a link to each downloaded file that is almost the same as the 
  filename - maybe this made sense in mdqt 0.1.0 but it's quite useless now. If anyone can remember what it was
  actually for I'll put it back.

## 0.5.0

### New Features

- New `entities` command extracts entity IDs and sha1 hashes from metadata files on disk
- New `ln` command will create symlinks to files using their sha1 hashes
- New `ls` command will list the entity IDs of metadata files
- New `list` command lists all entity IDs available from the MDQ service
- New `services` command shows known MDQ services and aliases
- New `rename` command renames metadata files to use their sha1 hash as a name 
- New `url` command shows the full url for an entity at the MDQ service

### Improvements

- Known MDQ services can be specified using simple aliases as well as URLs
- Caching is now on by default
- `--refresh` options forces downloads and ignores cached data
- Cache is cleaned whenever `get` is used, to remove expired files
- Added default service details for DFN
- Tidier output when stopped with ctrl-c

### Fixes

- Compatible with Ruby 3
- Updated dependencies to latest versions
- Improved test reliability and added more tests
- Extended timeouts to better handle slow networks

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
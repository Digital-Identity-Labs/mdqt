# Changelog

## 0.2.0

### Improvements
- Option to cache HTTP requests to the MDQ service
- Supports Gzip compression by default
- Supports redirect responses
- Helpful error messages and status messages
- Verbose mode will show successful connection information
- Warnings about unspecified MDQ service
- Default MDQ service selection (rather crude, maybe not a good idea at all)
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
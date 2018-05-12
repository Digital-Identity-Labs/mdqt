require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 60
  config.io_wait_timeout = 20
end

require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 15
  config.io_wait_timeout = 5
end

Before('@slow_process') do
  aruba.config.exit_timeout = 90
  aruba.config.io_wait_timeout = 20
end
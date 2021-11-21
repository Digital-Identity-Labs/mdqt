require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 30
  config.io_wait_timeout = 15
end

Before('@slow_process') do
  aruba.config.exit_timeout = 180
  aruba.config.io_wait_timeout = 120
end
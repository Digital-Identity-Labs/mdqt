require 'aruba/cucumber'

puts Dir.pwd

Aruba.configure do |config|
  config.exit_timeout = 15
  config.io_wait_timeout = 5

  puts config.command_search_paths

end

Before('@slow_process') do
  config.exit_timeout = 90
  aruba.config.io_wait_timeout = 20
end
Then("the current version number") do
  require_relative "../../lib/mdqt/version"
  step %Q|the output should contain "#{MDQT::VERSION}"|
end
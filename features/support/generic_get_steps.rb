
Then("the output to stdout should include {string}") do |string|

end

Then("the output to stdout should not include {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("that I have defined an MDQ service that supports aggregates") do
  ENV["MDQT_SERVICE"] = "https://mdq.incommon.org/"
end

Given("that I have defined an MDQ service that does not support aggregates") do
  ENV["MDQT_SERVICE"] = "http://mdq.ukfederation.org.uk/"
end

Given("that I have defined an MDQ service that does not handle aggregate downloads properly") do
  ENV["MDQT_SERVICE"] = "https://mdq.incommon.org/"
end

Given("that I have defined an MDQ service") do
  ENV["MDQT_SERVICE"] = "http://mdq.ukfederation.org.uk/"
end

Given("that I have defined an MDQ service as {string} using {string}") do |service, var|
  set_environment_variable(var, service)
end

Given("that I have not defined an MDQ service") do
  delete_environment_variable("MDQT_SERVICE")
  delete_environment_variable("MDQ_BASE_URL")
end

Given("I have a known service in the locale {string}") do |string|
  # ?/^I have (\d+) cucumbers in my belly$/
end

Given(/I am in the locale (.._..\..+)/) do |locale|
  set_environment_variable('LANG', locale)
end

Given("I am in the locale NULL") do
  delete_environment_variable("LANG")
end
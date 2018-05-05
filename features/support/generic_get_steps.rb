Given("that I have defined an MDQ service") do
  ENV["MDQT_SERVICE"] = "http://mdq.ukfederation.org.uk/"
end

Then("the output to stdout should include {string}") do |string|

end

Then("the output to stdout should not include {string}") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end
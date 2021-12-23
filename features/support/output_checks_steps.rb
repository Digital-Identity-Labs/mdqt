


Then("the output should be over {int} long") do |lines|
  expect(last_command_started.output.chomp.lines.count).to be > lines
end
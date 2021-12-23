require_relative 'local_files_setup_steps'

Then("a symlink named {word} should be created") do |link_name|
  expect(File.symlink?("tmp/aruba/#{link_name}")).to be true
end

Then("the file for {word} should be renamed to {word}") do |entity, new_name|
  expect(File.exists?("tmp/aruba/#{new_name}")).to be true
  step("I have downloaded the metadata for #{entity} to old_file.xml")
  expect(FileUtils.identical?("tmp/aruba/old_file.xml", "tmp/aruba/#{new_name}"))
end

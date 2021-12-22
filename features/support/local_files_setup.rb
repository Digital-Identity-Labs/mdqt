Given("I have downloaded the metadata for {string} to {string}") do |entity, filename|

  case entity.to_s.downcase.strip
  when "indiid"
    source = "indiid.xml"
  when "ukamf test sp"
    source = "ukamf_test.xml"
  when "the university of manchester"
    source = "uom.xml"
  else
    source = entity.to_s.downcase.strip + ".xml"
  end

  FileUtils.copy_file("features/fixtures/#{source}", "tmp/aruba/#{filename}")

end

Given("I have downloaded the metadata for {word} to {word}") do |entity, filename|

  case entity.to_s.downcase.strip
  when "indiid"
    source = "indiid.xml"
  when "ukamftestsp"
    source = "ukamf_test.xml"
  when "uom"
    source = "uom.xml"
  else
    source = entity.to_s.downcase.strip + ".xml"
  end

  FileUtils.copy_file("features/fixtures/#{source}", "tmp/aruba/#{filename}")

end

Given("that I have a valid SAML metadata file") do
  FileUtils.copy_file('features/fixtures/valid.xml', 'tmp/aruba/valid.xml')
end

Given("that I have a valid ADFS SAML metadata file") do
  FileUtils.copy_file('features/fixtures/adfs.xml', 'tmp/aruba/adfs.xml')
end

Given("that I have a tampered SAML metadata file") do
  FileUtils.copy_file('features/fixtures/tampered.xml', 'tmp/aruba/tampered.xml')
end

Given("that I have an empty file") do
  FileUtils.copy_file('features/fixtures/empty.xml', 'tmp/aruba/empty.xml')
end

Given("that I have a badly formed file") do
  FileUtils.copy_file('features/fixtures/bad.xml', 'tmp/aruba/bad.xml')
end

Given("that I have a file with missing attributes") do
  FileUtils.copy_file('features/fixtures/missing.xml', 'tmp/aruba/missing.xml')
end
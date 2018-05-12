Given("that I have appropriate certificates") do
  FileUtils.copy_file('features/fixtures/mdq-beta-cert.pem', 'tmp/aruba/incommon.pem')
  FileUtils.copy_file('features/fixtures/ukfederation-mdq.pem', 'tmp/aruba/ukfederation.pem')
end

Given("that I have inappropriate certificates") do
  FileUtils.copy_file('features/fixtures/broken.pem', 'tmp/aruba/broken.pem')
end



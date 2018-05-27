Feature: Ignore Untrusted TLS certificate
  In order to develop new services with a minimum of fuss
  As a sysadmin
  I want to be able to ignore errors from using self-signed certificates on non-production services but still feel guilty

  Scenario: Connecting to a service that uses a trusted TLS certificate
    # Given that I have defined an MDQ service that uses a CA-signed, trusted certificate

  Scenario: Connecting to an service that uses an untrusted TLS certificate
    # Given that I have defined an MDQ service that uses a self-signed, untrusted certificate


  ## TODO: Need to add more tests (especially for negative results) when have proper test server running
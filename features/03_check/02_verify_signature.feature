Feature: Verify Signed Metadata XML Files
  In order to use an SP or IdP securely
  As a sysadmin or service
  I need to check that metadata XML saved on disk has not been tampered with

  Scenario: Signed XML is verified, with verbosity enabled, using correct certificate
    Given that I have a valid SAML metadata file
    And that I have appropriate certificates
    When I run `mdqt check --verbose --verify-with ukfederation.pem valid.xml`
    Then the output should contain "Signature verification is available and active for this request"
    Then the output should contain "Signed XML"
    Then the output should contain "has been verified using"
    And the exit status should be 0

  Scenario: Signed XML is verified, without verbosity enabled, using correct certificate
    Given that I have a valid SAML metadata file
    And that I have appropriate certificates
    When I run `mdqt check --verify-with ukfederation.pem valid.xml`
    Then the exit status should be 0
    And the output should not contain "Signature verification is available and active for this request"
    And the output should not contain "valid.xml is valid SAML Metadata XML"

  Scenario: Signed XML is verified, with verbosity enabled, using more than one certificate
    Given that I have a valid SAML metadata file
    And that I have appropriate certificates
    When I run `mdqt check --verbose --verify-with ukfederation.pem,incommon.pem valid.xml`
    Then the exit status should be 0
    Then the output should contain "Signed XML"
    Then the output should contain "has been verified using"

  Scenario: Signed but tampered-with XML fails verification
    Given that I have a tampered SAML metadata file
    And that I have appropriate certificates
    When I run `mdqt check --verify-with ukfederation.pem tampered.xml`
    Then the exit status should not be 0
    And the output should contain "Error: The signed XML for"
    And the output should contain "cannot be verified using"

  Scenario: Signed XML is verified, without verbosity enabled, using incorrect certificate
    Given that I have a valid SAML metadata file
    And that I have appropriate certificates
    When I run `mdqt check --verify-with incommon.pem valid.xml`
    Then the exit status should not be 0
    And the output should contain "Error: The signed XML for"
    And the output should contain "cannot be verified using"

  Scenario: Signed XML is verified, with verbosity enabled, using broken certificate
    Given that I have a valid SAML metadata file
    Given that I have inappropriate certificates
    When I run `mdqt check --verify-with broken.pem --verbose valid.xml`
    Then the exit status should not be 0
    And the output should contain "File at 'broken.pem' does not seem to be a PEM format certificate"
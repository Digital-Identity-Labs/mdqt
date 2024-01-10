Feature: Validate Metadata XML Files
  In order to use an SP or IdP reliably
  As a sysadmin or service
  I want to be able to check that metadata XML already saved on disk is correct

  Scenario: Valid, schema-compliant XML is checked, with verbosity enabled
    Given that I have a valid SAML metadata file
    When I run `mdqt check --verbose valid.xml`
    Then the output should contain "XML validation is available and active for this request"
    Then the output should contain "valid.xml is valid SAML Metadata XML"
    And the exit status should be 0

  Scenario: Valid, schema-compliant XML is checked, without verbosity enabled
    Given that I have a valid SAML metadata file
    When I run `mdqt check valid.xml`
    Then the exit status should be 0
    And the output should not contain "valid.xml is valid SAML Metadata XML"

  Scenario: An empty file is checked
    Given that I have an empty file
    When I run `mdqt check empty.xml`
    Then the exit status should not be 0
    And the output should contain "Error: XML validation failed"
    And the output should contain "Empty document"

  Scenario: A badly formed metadata XML file is checked
    Given that I have a badly formed file
    When I run `mdqt check bad.xml`
    Then the exit status should not be 0
    And the output should contain "Error: XML validation failed"
    And the output should match /FATAL: Opening and ending tag mismatch/

  Scenario: Metadata XML with missing mandatory attributes is checked
    Given that I have a file with missing attributes
    When I run `mdqt check missing.xml`
    Then the exit status should not be 0
    And the output should contain "Error: XML validation failed"
    And the output should match /(The attribute 'entityID' is required but missing|Attribute 'entityID' must appear on element 'EntityDescriptor')/

  Scenario: Valid, schema-compliant huge WS-federation-bloated ADFS metadata is checked, without verbosity enabled
    Given that I have a valid ADFS SAML metadata file
    When I run `mdqt check adfs.xml`
    Then the exit status should be 0

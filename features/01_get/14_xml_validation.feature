Feature: Validate Metadata XML
  In order to use an SP or IdP reliably
  As a sysadmin or service
  I want to be able to check that metadata XML is correct

  Scenario: Valid, schema-compliant XML is checked, with verbosity enabled
    Given that I have defined an MDQ service as "<service>" using "<env_var>"
    When I run `mdqt get --cache --verbose --validate https://indiid.net/idp/shibboleth`
    Then the output should contain "Data for https://indiid.net/idp/shibboleth has been validated against schema"
    And the output should contain "EntityDescriptor"
    And the exit status should be 0

  Scenario: Valid, schema-compliant XML is checked, without verbosity enabled
    Given that I have defined an MDQ service as "<service>" using "<env_var>"
    When I run `mdqt get --cache --validate https://indiid.net/idp/shibboleth`
    Then the exit status should be 0
    And the output should not contain "Data for https://indiid.net/idp/shibboleth has been validated against schema"

  ## TODO: Need to add more tests (especially for negative results) when have proper test server running
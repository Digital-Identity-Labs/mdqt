Feature: Get Entity
  In order to use an SP or IdP efficiently
  As a sysadmin or service
  I want to be able to download just its metadata

  Scenario: The entity exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get https://indiid.net/idp/shibboleth`
    Then the output should contain "EntityDescriptor"

  Scenario: The entity does not exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get http://example.com/does_not_exist`
    Then the output should not contain "EntityDescriptor"
    And  the output should contain "[404]"
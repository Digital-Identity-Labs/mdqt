Feature: Get Entity
  In order to use an SP or IdP effiently
  As a sysadmin or service
  I want to be able to download just its metadata

  Scenario: The entity exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get https://indiid.net/idp/shibboleth`
    Then the output should contain "EntityDescriptor"

  Scenario: The entity does not exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get https://does.net/exist`
    Then the output should not contain "entityDescriptor"
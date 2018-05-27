Feature: Get Entity By SHA1 Transformed Identifier
  In order to use an SP or IdP reliably
  As a sysadmin or service
  I want to be able to specify an entity by a hash of its entity URI

  Scenario: The entity exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get {sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171`
    Then the output should contain "EntityDescriptor"
    And the output should contain "https://indiid.net/idp/shibboleth"

  Scenario: The entity does not exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get {sha1}945999b490c5665ac3854fd0f60352b2a46b8624`
    Then the output should not contain "EntityDescriptor"
    And  the output should contain "[404]"
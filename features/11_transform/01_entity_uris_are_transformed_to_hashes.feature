Feature: Show the sha1 hash for an entity ID URI
  In order to test MDQ APIs
  As a forgetful sysadmin with other things to do
  I want to see the sha1 hash for an entity ID URI

  Scenario Outline: Entity ID URI is supplied
    Given that I have defined the MDQ service as <service>
    When I run `mdqt transform <entity_id>`
    Then the output should contain "<hash>"
    And the exit status should be 0

    Examples:
      | entity_id                               | hash                                           |
      | https://indiid.net/idp/shibboleth       | {sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171 |
      | https://test.ukfederation.org.uk/entity | {sha1}c0045678aa1b1e04e85d412f428ea95d2f627255 |
    


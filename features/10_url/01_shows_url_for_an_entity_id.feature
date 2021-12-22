Feature: Shows direct MDQ URL for the specified entity ID
  In order to directly download metadata for specific entities
  As a forgetful sysadmin with other things to do who can't remember URLs
  I want to see the full URL for an entity at the current MDQ service

  Scenario Outline: Full entity IDs are supplied
    Given that I have defined the MDQ service as <service>
    When I run `mdqt url <entity_id>`
    Then the output should contain "<url>"
    And the exit status should be 0

    Examples:
      | service | entity_id | url       |
      | http://mdq.ukfederation.org.uk/ | https://indiid.net/idp/shibboleth | http://mdq.ukfederation.org.uk/entities/https%3A%2F%2Findiid.net%2Fidp%2Fshibboleth |
      | http://mdq.ukfederation.org.uk/ | https://test.ukfederation.org.uk/entity | http://mdq.ukfederation.org.uk/entities/https%3A%2F%2Ftest.ukfederation.org.uk%2Fentity |
      | https://mdq.incommon.org/ | https://test.ukfederation.org.uk/entity | https://mdq.incommon.org/entities/https%3A%2F%2Ftest.ukfederation.org.uk%2Fentity |

  Scenario Outline: Hashed entity IDs are supplied
    Given that I have defined the MDQ service as <service>
    When I run `mdqt url <entity_id>`
    Then the output should contain "<url>"
    And the exit status should be 0

    Examples:
      | service | entity_id | url       |
      | http://mdq.ukfederation.org.uk/ | {sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171 | http://mdq.ukfederation.org.uk/entities/%7Bsha1%7D77603e0cbda1e00d50373ca8ca20a375f5d1f171 |
      | http://mdq.ukfederation.org.uk/ | {sha1}c0045678aa1b1e04e85d412f428ea95d2f627255 | http://mdq.ukfederation.org.uk/entities/%7Bsha1%7Dc0045678aa1b1e04e85d412f428ea95d2f627255 |
      | https://mdq.incommon.org/ | {sha1}c0045678aa1b1e04e85d412f428ea95d2f627255 | https://mdq.incommon.org/entities/%7Bsha1%7Dc0045678aa1b1e04e85d412f428ea95d2f627255 |


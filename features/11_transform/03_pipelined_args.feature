Feature: Pipelined entity arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify entities using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single entity ID that exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo 'https://indiid.net/idp/shibboleth' | mdqt transform"`
    Then the output should contain "{sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171"

  @uses_pipes
  Scenario: A list of entity IDs, one per line, that exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth\nhttps://test.ukfederation.org.uk/entity' | mdqt transform"`
    Then the output should contain "{sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171"
    Then the output should contain "{sha1}c0045678aa1b1e04e85d412f428ea95d2f627255"

  @uses_pipes
  Scenario: A list of entity IDs, separated by spaces, that exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth https://test.ukfederation.org.uk/entity' | mdqt transform"`
    Then the output should contain "{sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171"
    Then the output should contain "{sha1}c0045678aa1b1e04e85d412f428ea95d2f627255"

  @uses_pipes
  Scenario: A list of entity IDs, separated by spaces and on multiple lines (utter chaos) that exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth https://test.ukfederation.org.uk/entity\nhttps://shib.manchester.ac.uk/shibboleth' | mdqt transform"`
    Then the output should contain "{sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171"
    Then the output should contain "{sha1}c0045678aa1b1e04e85d412f428ea95d2f627255"
    Then the output should contain "{sha1}b8883806b88f0754889c09e03b3576370c0d967f"

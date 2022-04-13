Feature: Pipelined entity arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify entities using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single entity ID that exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo 'https://indiid.net/idp/shibboleth' | mdqt get"`
    Then the output should contain "EntityDescriptor"

  @uses_pipes
  Scenario: A single entity ID that does not exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo 'http://example.com/does_not_exist' | mdqt get"`
    Then the output should not contain "EntityDescriptor"
    And  the output should contain "[404]"

  @uses_pipes
  Scenario: A list of entity IDs, one per line, that exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth\nhttps://test.ukfederation.org.uk/entity' | mdqt get"`
    Then the output should contain "EntityDescriptor"
    Then the output should contain "https://indiid.net/idp/shibboleth"
    Then the output should contain "https://test.ukfederation.org.uk/entity"

  @uses_pipes
  Scenario: A list of entity IDs, separated by spaces, that exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth https://test.ukfederation.org.uk/entity' | mdqt get"`
    Then the output should contain "EntityDescriptor"
    Then the output should contain "https://indiid.net/idp/shibboleth"
    Then the output should contain "https://test.ukfederation.org.uk/entity"

  @uses_pipes
  Scenario: A list of entity IDs, separated by spaces and on multiple lines (utter chaos) that exist on the MDQ service
    Given that I have defined an MDQ service
    When I run `bash -c "echo -e 'https://indiid.net/idp/shibboleth https://test.ukfederation.org.uk/entity\nhttps://shib.manchester.ac.uk/shibboleth' | mdqt get"`
    Then the output should contain "EntityDescriptor"
    Then the output should contain "https://indiid.net/idp/shibboleth"
    Then the output should contain "https://test.ukfederation.org.uk/entity"
    Then the output should contain "https://shib.manchester.ac.uk/shibboleth"

  @uses_pipes
  Scenario: A single entity ID that exists on the MDQ service but --all is also specified
    Given that I have defined an MDQ service
    When I run `bash -c "echo 'https://indiid.net/idp/shibboleth' | mdqt get --all"`
    Then the output should contain "EntityDescriptor"
    Then the output should not contain "EntitiesDescriptor"
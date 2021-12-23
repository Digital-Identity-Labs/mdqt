Feature: Lists all entity IDs inside a specified metadata file
  In order to check if an entity is contained in a file
  As a lazy sysadmin with other things to do
  I want to see the entity ID of the specified files

  Scenario Outline: A file is downloaded and passed to mdqt ls
    Given that I have defined an MDQ service
    And I have downloaded the metadata for <entity> to <file>
    When I run `mdqt entities <file>`
    Then the output should contain "<entity_id>"
    And the exit status should be 0

    Examples:
      | entity | file | entity_id |
      | Indiid |  indiid.xml | https://indiid.net/idp/shibboleth |
      | UoM | uom.xml | https://shib.manchester.ac.uk/shibboleth |

  Scenario: The file to be listed is an aggregate
    Given that I have defined an MDQ service
    And I have downloaded the metadata for aggregate to aggregate.xml
    When I run `mdqt entities aggregate.xml`
    Then the exit status should be 0
    And the output should not contain "Error: "
    And the output should contain "https://test.ukfederation.org.uk/entity\nhttps://indiid.net/idp/shibboleth"
    And the output should be over 1 long
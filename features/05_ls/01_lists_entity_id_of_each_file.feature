Feature: Lists entity ID of a specified metadata file
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to see the entity ID of the specified files

  Scenario Outline: A file is downloaded and passed to mdqt ls
    Given that I have defined an MDQ service
    And I have downloaded the metadata for <entity> to <file>
    When I run `mdqt ls <file>`
    Then the output should contain "<entity_id>"
    Then the output should contain "<type>"
    Then the output should contain "<file>"
    And the exit status should be 0

    Examples:
      | entity | file | entity_id | type |
      | Indiid |  indiid.xml | https://indiid.net/idp/shibboleth | entity |
      | UoM | uom.xml | https://shib.manchester.ac.uk/shibboleth | entity |

  Scenario: The file to be listed is an aggregate
    Given that I have defined an MDQ service
    And I have downloaded the metadata for aggregate to aggregate.xml
    When I run `mdqt ls aggregate.xml`
    Then the exit status should be 0
    And the output should not contain "Error: "

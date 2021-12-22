Feature: Rename metadata files to their sha1 entity ID hash
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to have my metadata files renamed to their hashed entity IDs for me

  Scenario Outline: A file is downloaded and renamed
    Given that I have defined an MDQ service
    And I have downloaded the metadata for <entity> to <file>
    When I run `mdqt rename <file>`
    Then the file should be renamed to <new_name>
    And the exit status should be 0

    Examples:
      | entity | file       | new_name                                     |
      | Indiid | indiid.xml | 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml |
      | UoM    | uom.xml    | b8883806b88f0754889c09e03b3576370c0d967f.xml |

  Scenario: A file with the new name already exists
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to file1.xml
    And I run `cp file1.xml 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt rename file1.xml`
    Then the exit status should be 1
    And the output should contain "Error: "
    And the output should contain "File exists! Use --force to override"

  Scenario: The file to be renamed is an aggregate
    Given that I have defined an MDQ service
    And I have downloaded the metadata for aggregate to aggregate.xml
    When I run `mdqt rename aggregate.xml`
    Then the exit status should be 1
    And the output should contain "Error: "
    And the output should contain "File aggregate.xml is a metadata aggregate, cannot rename to hashed entityID!"

Feature: Lists all entity IDs inside a specified metadata file, and include sha1 hashes
  In order to check if an entity is contained in a file
  As a lazy sysadmin with other things to do
  I want to see the entity ID of the specified files and the sha1 hash

  Scenario Outline: A file is downloaded and passed to mdqt ls, with the --sha1 option set
    Given that I have defined an MDQ service
    And I have downloaded the metadata for <entity> to <file>
    When I run `mdqt entities --sha1 <file>`
    Then the output should contain "<entity_id>"
    Then the output should contain "<sha1>"
    And the exit status should be 0

    Examples:
      | entity | file       | entity_id                                | sha1                                           |
      | Indiid | indiid.xml | https://indiid.net/idp/shibboleth        | {sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171 |
      | UoM    | uom.xml    | https://shib.manchester.ac.uk/shibboleth | {sha1}b8883806b88f0754889c09e03b3576370c0d967f |

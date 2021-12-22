Feature: Create sha1 alias to a metadata file
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to have my sha1 links to the metadata created for me

  Scenario Outline: A file is downloaded and then a link is created
    Given that I have defined an MDQ service
    And I have downloaded the metadata for <entity> to <file>
    When I run `echo $PWD ; mdqt ln <file>`
    Then a symlink named <link> should be created
    And the exit status should be 0

    Examples:
      | entity | file | link |
      | Indiid |  indiid.xml | 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml |
      | The University of Manchester | uom.xml | b8883806b88f0754889c09e03b3576370c0d967f.xml |

  Scenario: The sha1 link already exists to the same file
    Given that I have defined an MDQ service
    And I have downloaded the metadata for "Indiid" to "file1.xml"
    And I run `ln -s file1.xml 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt ln file1.xml`
    Then the exit status should be 1
    And the output should contain "Error: "
    And the output should contain "File exists. Use --force to override"

  Scenario: The sha1 link already exists to a different file
    Given that I have defined an MDQ service
    And I have downloaded the metadata for "Indiid" to "file1.xml"
    And I have downloaded the metadata for "Indiid" to "file2.xml"
    And I run `ln -s file2.xml 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt ln file1.xml`
    Then the exit status should be 1
    And the output should contain "Error: "
    And the output should contain "Conflicts with file1.xml. Use --force to override"

  Scenario: The sha1 link has the same name as the original file
    Given that I have defined an MDQ service
    And I have downloaded the metadata for "Indiid" to "77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml"
    When I run `mdqt ln 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    Then the exit status should be 1
    And the output should contain "Error: "
    And the output should contain "Cannot link file to itself!"


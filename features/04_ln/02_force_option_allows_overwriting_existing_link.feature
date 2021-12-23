Feature: Create sha1 alias to a metadata file despite warnings
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to have my sha1 links to the metadata created for me
  Despite warnings that there are potential problems

  Scenario: The sha1 link already exists to the same file but force is set
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to file1.xml
    And I run `ln -s file1.xml 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt ln file1.xml --force`
    Then the exit status should be 0
    And the output should not contain "Error: "

  Scenario: The sha1 link already exists to a different file but force is set
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to file1.xml
    And I have downloaded the metadata for Indiid to file2.xml
    And I run `ln -s file2.xml 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt ln file1.xml --force`
    Then the exit status should be 0
    And the output should not contain "Error: "

  Scenario: The sha1 link has the same name as the original file and force is set but it's still impossible
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml
    When I run `mdqt ln --force 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    Then the exit status should be 0
    And the output should not contain "Error: "
    And the output should contain "Warning: "
    And the output should contain "Cannot link file to itself, skipping!"


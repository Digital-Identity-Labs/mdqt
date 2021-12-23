Feature: Rename a metadata file despite dangers
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to automatically rename metadata files
  Despite warnings that there are potential problems

  Scenario: A file with the new name already exists but force option is set
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to file1.xml
    And I run `echo "boop" > 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml`
    When I run `mdqt rename --force file1.xml`
    Then the exit status should be 0
    And the file for Indiid should be renamed to 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml
    And the output should not contain "Error: "

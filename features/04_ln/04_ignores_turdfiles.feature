Feature: Emacs turd files and other backup files are ignored
  As a sysadmin editing metadatafiles with emacs
  While renaming those files to be named after their entity ID sha1 hash
  I do not want to accidentally link to turd files containing the previous version

  Scenario: An emacs turd file
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to indiid.xml
    When I run `mv indiid.xml indiid.xml~`
    And I run `mdqt rename indiid.xml~`
    Then the exit status should be 0
    And the output should contain "Warning: "
    And the output should contain "will not process backup/turd files"

  Scenario: A file with a .bak extension
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to indiid.xml
    When I run `mv indiid.xml indiid.xml.bak`
    And I run `mdqt rename indiid.xml.bak`
    Then the exit status should be 0
    And the output should contain "Warning: "
    And the output should contain "will not process backup/turd files"
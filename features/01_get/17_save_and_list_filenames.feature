Feature: Save Metadata To Disk and output filenames to stdout
  In order to save metadata and then act on it with other commandss
  As a sysadmin or service
  I want to be able to save metadata directly to disk and print the names of files

  Scenario: The entity exists on the MDQ service and --list is enabled
    Given that I have defined an MDQ service
    When I run `mdqt get --cache --save-to out https://indiid.net/idp/shibboleth --list`
    And I cd to "out"
    Then a file named "77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml" should exist
    Then the output should contain "out/77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml"

  Scenario: Multiple entities are specified and --list is enabled
    Given that I have defined an MDQ service
    When I run `mdqt get https://indiid.net/idp/shibboleth https://test.ukfederation.org.uk/entity https://shib.manchester.ac.uk/shibboleth --save-to out --list`
    And I cd to "out"
    Then a file named "77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml" should exist
    Then a file named "c0045678aa1b1e04e85d412f428ea95d2f627255.xml" should exist
    Then a file named "b8883806b88f0754889c09e03b3576370c0d967f.xml" should exist
    Then the output should contain "out/77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml"
    Then the output should contain "out/c0045678aa1b1e04e85d412f428ea95d2f627255.xml"
    Then the output should contain "out/b8883806b88f0754889c09e03b3576370c0d967f.xml"





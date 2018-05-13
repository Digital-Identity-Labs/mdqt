Feature: Display Of Version
  In order to use the desired version of MDQT
  As any user of MDQT
  I want to see the version of the current library and application

  Scenario: The application and library version is required
    When I run `mdqt version`
    Then the output should contain "MDQT version"
    And  the current version number

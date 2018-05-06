Feature: Get Entity Aggregate
  In order to emulate traditional aggregated metadata files
  As a sysadmin or service
  I want to be able to download all entities at once

  Scenario: The MDQ service supports aggregate downloads
    Given that I have defined an MDQ service that supports aggregates
    When I run `mdqt get --all`
    Then the output should contain "EntitiesDescriptor"

#  Scenario: The MDQ service does not support aggregate downloads
#    Given that I have defined an MDQ service that does not support aggregates
#    When I run `mdqt get --all`
#    Then the output should not contain "EntitiesDescriptor"
#    And  the output should contain "[403]"

#  Scenario: The MDQ service does not handle aggregate downloads properly
#    Given that I have defined an MDQ service that does not handle aggregate downloads properly
#    When I run `mdqt get --all`
#    Then the output should contain "is not responding with aggregated metadata, or the correct status"
#    And  the output should contain "[404]"

  Scenario: The user has not explicitly requested all entities
    Given that I have defined an MDQ service that supports aggregates
    When I run `mdqt get`
    Then the output should contain "Please specify --all if you wish to request all entities"

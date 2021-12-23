Feature: Lists entity ID of each metadata file in directory by default
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to see the entity ID of each file in a directory if no files are specified

  Scenario: A file is downloaded and then a link is created
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to indiid.xml
    And I have downloaded the metadata for UoM to uom.xml
    And I have downloaded the metadata for Aggregate to aggregate.xml
    When I run `mdqt ls`
    Then the output should contain "https://indiid.net/idp/shibboleth, entity, indiid.xml"
    Then the output should contain "https://shib.manchester.ac.uk/shibboleth, entity, uom.xml"
    Then the output should not contain "aggregate.xml"
    And the exit status should be 0

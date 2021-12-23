Feature: Lists all entity IDs at the specified service
  In order to use individual metadata files with Shibboleth IdP or SP
  As a lazy sysadmin with other things to do
  I want to see the entity ID of the specified files

  Scenario Outline: A service is specified
    Given that I have defined the MDQ service as <service>
    When I run `mdqt list`
    Then the output should contain "<fragment>"
    Then the output should be over <lines> long
    And the exit status should be 0

    Examples:
      | service | fragment | lines |
      | http://mdq.ukfederation.org.uk/ | https://idp2.iay.org.uk/idp/shibboleth\nurn:mace:ac.uk:sdss.ac.uk:provider:identity:dur.ac.uk | 8000 |
      | https://mdq.incommon.org/ | urn:mace:incommon:washington.edu | 10000|

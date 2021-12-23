Feature: Lists all known MDQ services and their aliases
  In order to see what services are already defined
  As a lazy sysadmin with other things to do
  I want to see a list of service URLs and aliases

  Scenario: Built-in services are listed
    Given that I have defined an MDQ service
    When I run `mdqt services`
    Then the exit status should be 0
    And the output should not contain "Error: "
    And the output should contain "ukamf: http://mdq.ukfederation.org.uk/"
    And the output should contain "incommon: https://mdq.incommon.org/"
    And the output should contain "dfn: https://mdq.aai.dfn.de"
    And the output should be over 2 long





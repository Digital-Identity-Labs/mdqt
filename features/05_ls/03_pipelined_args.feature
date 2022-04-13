Feature: Pipelined filename arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify filenames using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single filename that exists on the MDQ service
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to indiid.xml
    When I run `bash -c "echo 'indiid.xml' | mdqt ls"`
    Then the output should contain "https://indiid.net/idp/shibboleth"
    Then the output should contain "entity"
    Then the output should contain "indiid.xml"
    And the exit status should be 0
Feature: Pipelined filename arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify filenames using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single filename that exists on the filesystem
    Given that I have a valid SAML metadata file
    When I run `bash -c "echo 'valid.xml' | mdqt check --verbose"`
    Then the output should contain "XML validation is available and active for this request"
    Then the output should contain "valid.xml is valid SAML Metadata XML"
    And the exit status should be 0

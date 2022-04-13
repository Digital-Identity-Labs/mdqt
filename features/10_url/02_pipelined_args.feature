Feature: Pipelined entity arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify entities using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single entity ID that exists on the MDQ service
    Given that I have defined the MDQ service as http://mdq.ukfederation.org.uk/
    When I run `bash -c "echo 'https://test.ukfederation.org.uk/entity' | mdqt url"`
    Then the output should contain "http://mdq.ukfederation.org.uk/entities/https%3A%2F%2Ftest.ukfederation.org.uk%2Fentity"
    And the exit status should be 0

Feature: Pipelined filename arguments
  In order to build pipelined functions
  As a sysadmin or service
  I want to be able to specify filenames using a POSIX pipeline/STDIN

  @uses_pipes
  Scenario: A single filename that exists on the MDQ service
    Given that I have defined an MDQ service
    And I have downloaded the metadata for Indiid to indiid.xml
    When I run `bash -c "echo 'indiid.xml' | mdqt ln"`
    Then a symlink named 77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml should be created
    And the exit status should be 0

Feature: Transform Entity ID URI
  In order to work with MDQ requests
  As a sysadmin
  I want to be able to convert entity URI identifiers to the transformed {sha1} format

  Scenario: The example from the specification
    When I run `mdqt transform http://example.org/service`
    Then the output should contain "{sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb"

  Scenario: URN-style identifiers
    When I run `mdqt transform urn:mace:ac.uk:sdss.ac.uk:provider:identity:uhi.ac.uk`
    Then the output should contain "{sha1}8c3f779c9dff67b104eaf71d113aa699161f0e2e"

  Scenario: Correct SHA1 transformed identifiers are not reprocessed
    When I run `mdqt transform {sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb`
    Then the output should contain "{sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb"

  Scenario: Lazy SHA1 transformed identifiers are not reprocessed
    When I run `mdqt transform [sha1]11d72e8cf351eb6c75c721e838f469677ab41bdb`
    Then the output should contain "{sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb"

  Scenario: FISH-mangled SHA1 transformed identifiers are corrected reprocessed
    When I run `mdqt transform sha111d72e8cf351eb6c75c721e838f469677ab41bdb`
    Then the output should contain "{sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb"

  Scenario: More than one entity URI should be transformed
    When I run `mdqt transform http://example.org/service https://indiid.net/idp/shibboleth {sha1}8c3f779c9dff67b104eaf71d113aa699161f0e2e`
    Then the output should contain "{sha1}11d72e8cf351eb6c75c721e838f469677ab41bdb"
    Then the output should contain "{sha1}77603e0cbda1e00d50373ca8ca20a375f5d1f171"
    Then the output should contain "{sha1}8c3f779c9dff67b104eaf71d113aa699161f0e2e"




  #
Feature: Save Metadata To Disk
  In order to use an SP or IdP reliably
  As a sysadmin or service
  I want to be able to save metadata directly to disk

  @announce-directory @announce-output
  Scenario: The entity exists on the MDQ service
    Given that I have defined an MDQ service
    When I run `mdqt get --verbose --service http://mdq.ukfederation.org.uk/ --save-to out https://indiid.net/idp/shibboleth `
    And I cd to "out"
    Then a file named "77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml" should exist
    And the file named "77603e0cbda1e00d50373ca8ca20a375f5d1f171.xml" should contain "https://indiid.net/idp/shibboleth"

#  @announce-directory
#  Scenario: The entity does not exist on the MDQ service
#    Given that I have defined an MDQ service
#    When I run `mdqt get --verbose --service http://mdq.ukfederation.org.uk/ http://example.com/does_not_exist --save-to out`
#    And I cd to "out"
#    Then a file named "0ae6c641fa657afa8a060e5845cd9f25a1bc59db.xml" should not exist
#
#  @slow_process
#  Scenario: An aggregate has been requested (and is available)
#    Given that I have defined an MDQ service
#    When I run `mdqt get --verbose --service http://mdq.ukfederation.org.uk/ --all --save-to out`
#    And I cd to "out"
#    Then a file named "aggregate-bf74cb27d99de27ac1618ebf480c5af821036d24.xml" should exist
#    And the file named "aggregate-bf74cb27d99de27ac1618ebf480c5af821036d24.xml" should contain "EntitiesDescriptor"
#
#  Scenario: The entity is signed and does not pass verification
#    Given that I have appropriate certificates
#    When I run `mdqt get --verbose --service http://mdq.ukfederation.org.uk/ --verify-with incommon.pem --save-to out https://indiid.net/idp/shibboleth`
#    Then the output should contain "The data for https://indiid.net/idp/shibboleth cannot be verified using incommon.pem"
#    And I cd to "out"
#    And a file named "0ae6c641fa657afa8a060e5845cd9f25a1bc59db.xml" should not exist
#
#

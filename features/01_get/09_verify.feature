Feature: Verify Metadata Signature
  In order to use an SP or IdP securely
  As a sysadmin or service
  I want to be able to verify the signature on SAML metadata

  Scenario: The signed entity metadata is verified against the correct certificate
    Given that I have appropriate certificates
    When I run `mdqt get --cache --verbose --service http://mdq.ukfederation.org.uk/ --verify-with ukfederation.pem https://indiid.net/idp/shibboleth`
    Then the output should contain "Data for https://indiid.net/idp/shibboleth has been verified using 'ukfederation.pem'"

#  Scenario: The signed aggregate metadata is verified against the correct certificate  ## FIXME: Why is this timing out?
#    Given that I have appropriate certificates
#    When I run `mdqt get --cache --verbose --service http://mdq-beta.incommon.org/global --verify-with incommon.pem --all --save-to out`
#    Then the output should contain "Data for aggregate has been verified using 'incommon.pem'"

#  @slow_process
#  Scenario: The signed metadata is verified against an incorrect certificate  ## FIXME: Why is this timing out?
#    Given that I have appropriate certificates
#    When I run `mdqt get --cache --verbose --service http://mdq.ukfederation.org.uk/ --verify-with incommon.pem https://indiid.net/idp/shibboleth`
#    And I wait for output to contain "The data"
#    Then the output should contain "The data for https://indiid.net/idp/shibboleth cannot be verified using incommon.pem"

#  Scenario: Unsigned metadata is verified against a certificate
#    Given that I have appropriate certificates
#    When I run `mdqt get https://indiid.net/idp/shibboleth`
#    Then the output should contain "EntityDescriptor"

  Scenario: Missing metadata is not verified against a certificate
    Given that I have appropriate certificates
    When I run `mdqt get --cache --verbose --service http://mdq.ukfederation.org.uk/ --verify-with ukfederation.pem http://example.com/does_not_exist`
    Then the output should not contain "Data for aggregate has been verified using 'ukfederation.pem'"
    And  the output should contain "[404]"

  Scenario Outline: Verification is requested without a certificate being present or correct
    Given that I have inappropriate certificates
    When I run `mdqt get --cache --verbose --service http://mdq.ukfederation.org.uk/ --verify-with <cert_filename> https://indiid.net/idp/shibboleth`
    Then the output should contain "<message>"

    Examples:
      | cert_filename | message |
      | missing.pem | Error: Cannot read certificate at 'missing.pem'!  |
      | broken.pem | Error: File at 'broken.pem' does not seem to be a PEM format certificate  |


  Scenario: Validation of multiple entities is requested against the correct certificate
    Given that I have appropriate certificates
#    When I run `mdqt get https://indiid.net/idp/shibboleth`
#    Then the output should contain "EntityDescriptor"

  Scenario: Verification is requested with more than one certificate, one of which is correct
    Given that I have appropriate certificates
    When I run `mdqt get --cache --verbose --service http://mdq.ukfederation.org.uk/ --verify-with ukfederation.pem,incommon.pem https://indiid.net/idp/shibboleth https://www.jiscmail.ac.uk/shibboleth`
    Then the output should contain "Data for https://indiid.net/idp/shibboleth has been verified using 'ukfederation.pem and incommon.pem'"
    Then the output should contain "Data for https://www.jiscmail.ac.uk/shibboleth has been verified using 'ukfederation.pem and incommon.pem'"
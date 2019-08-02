Feature: Selection Of MDQ Service
  In order to lookup a local entity from a specific MDQ service
  As a serious sysadmin or secure production service
  I want to have the MDQ service clearly specified using an option or ENV variable

  Scenario: A default service is available but a service has been specified on the commandline
    Given  I have a known service in the locale "en_US.UTF-8"
    And  I am in the locale en_US.UTF-8
    When I run `mdqt get --service http://mdq.ukfederation.org.uk/ http://example.com/does_not_exist --verbose`
    Then the output should contain "Using http://mdq.ukfederation.org.uk/"

  Scenario: No default service is available and a service has been specified on the commandline
    Given  I am in the locale en_XX.UTF-8
    When I run `mdqt get --service http://mdq.ukfederation.org.uk/ http://example.com/does_not_exist --verbose`
    Then the output should contain "Using http://mdq.ukfederation.org.uk/"

  Scenario: No default service is available, no service has been specified on the commandline, no ENV variable is set
    Given that I have not defined an MDQ service
    And  I am in the locale en_XX.UTF-8
    When I run `mdqt get  http://example.com/does_not_exist --verbose`
    Then it should fail with "Please specify an MDQ service using --service, MDQT_SERVICE or MDQ_BASE_URL"

  Scenario Outline: The user has specified a service using an ENV variable
    Given that I have defined an MDQ service as "<service>" using "<env_var>"
    And  I have a known service in the locale "en_US.UTF-8"
    And  I am in the locale en_US.UTF-8
    When I run `mdqt get http://example.com/does_not_exist --verbose`
    Then the output should contain "Using <service>"

    Examples:
      | env_var | service |
      | MDQT_SERVICE | http://mdq.ukfederation.org.uk/  |
      | MDQ_BASE_URL | http://mdq.ukfederation.org.uk/  |


  Scenario: A service has been specified on the commandline *and* as an environment variable
    Given that I have defined an MDQ service as "http://mdq.example.com/" using "MDQT_SERVICE"
    When I run `mdqt get --service https://mdq.incommon.org/ http://example.com/does_not_exist --verbose`
    Then the output should contain "Using https://mdq.incommon.org/"

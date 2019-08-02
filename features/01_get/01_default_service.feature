Feature: Automatic Selection Of MDQ Service
  In order to quickly lookup a local entity
  As a lazy sysadmin or casual user
  I want to have my local MDQ service selected for me

  Scenario Outline: No service is specified, and the user has a known service in their locale
    Given that I have not defined an MDQ service
    And  I have a known service in the locale "<locale>"
    And  I am in the locale <locale>
    When I run `mdqt get http://example.com/does_not_exist`
    Then the output should contain "MDQT is assuming that you want to use <service>"
    And the output should contain "Please configure this using --service, MDQT_SERVICE or MDQ_BASE_URL"

  Examples:
  | locale | service |
  | en_GB.UTF-8 | http://mdq.ukfederation.org.uk/ |
  | en_US.UTF-8 | https://mdq.incommon.org/ |

  Scenario Outline: No service is specified, and the user has a locale with no associated MDQ service
    Given that I have not defined an MDQ service
    And  I am in the locale <locale>
    When I run `mdqt get http://example.com/does_not_exist`
    Then it should fail with "Please specify an MDQ service using --service, MDQT_SERVICE or MDQ_BASE_URL"

    Examples:
      | locale |
      | en_XX.UTF-8 |
      | NULL |

  Scenario Outline: The user has a known service in their locale but a service has been specified in the ENV
    Given that I have defined an MDQ service as "<service>" using "<env_var>"
    And  I have a known service in the locale "en_US.UTF-8"
    And  I am in the locale en_US.UTF-8
    When I run `mdqt get http://example.com/does_not_exist --verbose`
    Then the output should contain "Using <service>"

    Examples:
      | env_var | service |
      | MDQT_SERVICE | http://mdq.ukfederation.org.uk/ |
      | MDQ_BASE_URL | http://mdq.ukfederation.org.uk/ |

  Scenario: The user has a known service in their locale but a service has been specified on the commandline
    And  I have a known service in the locale "en_US.UTF-8"
    And  I am in the locale en_US.UTF-8
    When I run `mdqt get --service http://mdq.ukfederation.org.uk/ http://example.com/does_not_exist --verbose`
    Then the output should contain "Using http://mdq.ukfederation.org.uk/"

# device-identifier-matchIdentifier
Feature: Camara Mobile Device Identifier API, vwip - Operation: matchIdentifier

  # Input to be provided by the implementation to the tests
  # References to OAS spec schemas refer to schemas specified in /code/API_definitions/device-identifier.yaml
  # Implementation indications:
  # * api_root: API root of the server URL
  #
  # Testing assets:
  # * A mobile device "DEVICE1" with the following parameter values:
  #         | Parameter           | Value              |
  #         |---------------------|--------------------|
  #         | IMEISV              | IMEISV1            |
  #         | IMEI                | IMEI1              |
  #         | TAC                 | TAC1               |
  #         | Public IPv4 Address | PUBLICIPV4ADDRESS1 |
  #         | Public Port         | PUBLICPORT1        |
  # * A mobile device "DEVICE2" with the following parameter values:
  #         | Parameter           | Value              |
  #         |---------------------|--------------------|
  #         | IMEISV              | IMEISV2            |
  #         | IMEI                | IMEI2              |
  #         | TAC                 | TAC2               |
  #         | Public IPv4 Address | PUBLICIPV4ADDRESS2 |
  #         | Public Port         | PUBLICPORT2        |
  # * A SIM card "SIMCARD1" from "TELCO1" and phone number "PHONENUMBER1"
  # * A SIM card "SIMCARD2" from "TELCO2" and phone number "PHONENUMBER2"
  # * A fixed line or unsupported line identifier "UNSUPPORTED_LINE"

  Background: Common Device Identifier matchIdentifier setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/match-identifier"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the MatchRequestBody schema defined by "/components/schemas/MatchRequestBody"
    And one of the scopes associated with the access token is device-identifier:match-identifier

  # Success scenarios

  @DeviceIdentifier_matchIdentifier_200.01_success_scenario_3-legged_token
  Scenario Outline: Match current device identifier for DEVICE1 with SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And request property "$.providedIdentifierType" is set to "<providedIdentifierType>"
    And request property "$.providedIdentifier" is set to <providedIdentifier>
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

    Examples:
      | providedIdentifierType | providedIdentifier |
      | IMEI                   | IMEI1              |
      | IMEISV                 | IMEISV1            |
      | TAC                    | TAC1               |

  @DeviceIdentifier_matchIdentifier_200.02_success_scenario_2-legged_token_identifying_device_by_phone_number
  Scenario: Match current device identifier for DEVICE1 with SIMCARD1 identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And request property "$.providedIdentifierType" is set to "IMEI"
    And request property "$.providedIdentifier" is set to IMEI1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.02b_success_scenario_2-legged_token_identifying_device_by_phone_number_non_match
  Scenario: Non-match current device identifier for DEVICE1 with SIMCARD1 identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And request property "$.providedIdentifierType" is set to "IMEI"
    And request property "$.providedIdentifier" is set to IMEI2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is false
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.03_success_scenario_2-legged_token_identifying_device_by_IPv4_address
  Scenario: Match current device identifier for DEVICE1 with SIMCARD1 identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And request property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    And request property "$.providedIdentifierType" is set to "TAC"
    And request property "$.providedIdentifier" is set to TAC1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.03b_success_scenario_2-legged_token_identifying_device_by_IPv4_address_non_match
  Scenario: Non-match current device identifier for DEVICE1 with SIMCARD1 identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And request property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    And request property "$.providedIdentifierType" is set to "TAC"
    And request property "$.providedIdentifier" is set to TAC2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is false
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.04_success_scenario_2-legged_token_identifying_device_by_multiple_identifiers
  Scenario: Match current device identifier for DEVICE1 with SIMCARD1 identifying device by multiple identifiers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And request property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And request property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    And request property "$.providedIdentifierType" is set to "IMEISV"
    And request property "$.providedIdentifier" is set to IMEISV1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.04b_success_scenario_2-legged_token_identifying_device_by_multiple_identifiers_non_match
  Scenario: Non-match current device identifier for DEVICE1 with SIMCARD1 identifying device by multiple identifiers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And request property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And request property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    And request property "$.providedIdentifierType" is set to "IMEISV"
    And request property "$.providedIdentifier" is set to IMEISV2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is false
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  @DeviceIdentifier_matchIdentifier_200.05_success_scenario_3-legged_token_after_device_swap_mismatch
  Scenario Outline: Non-match for old device identifier after device swap using 3-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And request property "$.providedIdentifierType" is set to "<providedIdentifierType>"
    And request property "$.providedIdentifier" is set to <providedIdentifier>
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is false
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

    Examples:
      | providedIdentifierType | providedIdentifier |
      | IMEI                   | IMEI1              |
      | IMEISV                 | IMEISV1            |
      | TAC                    | TAC1               |

  @DeviceIdentifier_matchIdentifier_200.05b_success_scenario_3-legged_token_after_device_swap_match
  Scenario Outline: Match for new device identifier after device swap using 3-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And request property "$.providedIdentifierType" is set to "<providedIdentifierType>"
    And request property "$.providedIdentifier" is set to <providedIdentifier>
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

    Examples:
      | providedIdentifierType | providedIdentifier |
      | IMEI                   | IMEI2              |
      | IMEISV                 | IMEISV2            |
      | TAC                    | TAC2               |

  @DeviceIdentifier_matchIdentifier_200.06_success_scenario_2-legged_token_after_SIM_card_swap
  Scenario: Match current device identifier for DEVICE1 with SIMCARD2 using 2-legged access token
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER2
    And request property "$.providedIdentifierType" is set to "IMEI"
    And request property "$.providedIdentifier" is set to IMEI1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200MatchIdentifier schema at "/components/schemas/200MatchIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.match" exists and is true
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imei" does not exist
    And the response property "$.imeisv" does not exist
    And the response property "$.tac" does not exist
    And the response property "$.ppid" does not exist

  # Generic 400 errors

  @DeviceIdentifier_matchIdentifier_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is set to any value which is not compliant with the schema at "/components/schemas/MatchRequestBody"
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_400.2b_device_empty
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_400.3_device_identifiers_not_schema_compliant
  # Note that device schema validation errors (if any) should be thrown even if a 3-legged access token is being used
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    And a 2-legged or 3-legged access token is being used
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                       |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber       |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr    |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier |

  @DeviceIdentifier_matchIdentifier_400.4_invalid_identifier_type
  Scenario: Unsupported providedIdentifierType enum value
    Given the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    And the request body property "$.providedIdentifierType" is set to "INVALID_TYPE"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_400.5_invalid_identifier_format
  Scenario Outline: Provided identifier does not comply with the format required by the identifier type
    Given the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    And the request body property "$.providedIdentifierType" is set to "<providedIdentifierType>"
    And the request body property "$.providedIdentifier" is set to "<providedIdentifier>"
    When the request "matchIdentifier" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | providedIdentifierType | providedIdentifier  |
      | IMEI                   | 12345678901234      |
      | IMEISV                 | 123456789012345     |
      | TAC                    | 1234567             |
      | IMEI                   | 1234567890ABCD      |
      | TAC                    | 12!45678            |

  # Generic 401 errors

  @DeviceIdentifier_matchIdentifier_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "matchIdentifier" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "matchIdentifier" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "matchIdentifier" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 errors

  @DeviceIdentifier_matchIdentifier_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope device-identifier:match-identifier
    When the request "matchIdentifier" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Generic 404 errors

  @DeviceIdentifier_matchIdentifier_404.1_device_not_found
  Scenario: An identifier cannot be matched to a valid device
    Given that the device cannot be identified from the access token
    And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 422 errors

  @DeviceIdentifier_matchIdentifier_422.1_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_422.2_service_not_applicable
  Scenario: Service not applicable for the identified mobile device subscription
    Given that service is not applicable for the identified mobile device subscription due to line type, policy, regulation, or no deterministic device information being available
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_422.3_unidentifiable_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a device
    And the request body property "$.device" is not included
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    When the request "matchIdentifier" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_422.4_device_token_mismatch
  Scenario: Inconsistent access token context for the device
    Given the request body property "$.device" is set to a valid testing device
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    And the header "Authorization" is set to a valid access token obtained for a different device
    When the request "matchIdentifier" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_matchIdentifier_422.5_unnecessary_device_identifier_in_request
  Scenario: Explicit device identifier provided when device is identified by the access token
    Given the request body property "$.device" is set to a valid testing device
    And the request body property "$.providedIdentifierType" is set to "IMEI"
    And the request body property "$.providedIdentifier" is set to IMEI1
    And the header "Authorization" is set to a valid access token for that same device
    When the request "matchIdentifier" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

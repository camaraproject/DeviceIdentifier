@DeviceIdentifier_retrieve_identifier
Feature: Camara Device Identifer API, vwip - Operation: retrieveIdentifier

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in code/API_definitions/device-identifier.yaml
# Implementation indications:
# * api_root: API root of the server URL
#
# Testing assets:
# * a mobile device "DEVICE1" with IMEI "IMEI1", IMEISV "IMEISV1", public IPv4 address "PUBLICIPV4ADDRESS", and public port "PUBLICPORT"
# * a mobile device "DEVICE2" with IMEI "IMEI2", and IMEISV "IMEISV2"
# * a SIM card "SIMCARD1" from "TELCO1" and phone number "PHONENUMBER1"
# * a SIM card "SIMCARD2" from "TELCO2" and phone number "PHONENUMBER2"

  Background: Common Device Identifier retrieveIdentifier setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/retrieve-identifier"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is compliant with the RequestBody schema defined by "/components/schemas/RequestBody"

  # Success scenarios

  @DeviceIdentifier_retrieve_identifier_200.01_success_scenario_3-legged_token
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD1 with 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And DEVICE1 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV1

  @DeviceIdentifier_retrieve_identifier_200.02_success_scenario_2-legged_token_identifying_device_by_phone_number
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD1 identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And DEVICE1 is not identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV1

  @DeviceIdentifier_retrieve_identifier_200.03_success_scenario_2-legged_token_identifying_device_by_IPv4_address
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD1 identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And DEVICE1 is not identified by the access token
    And request property "$.device.ipv4address.publicAddress" is set to PUBLICIPV4ADDRESS
    And request property "$.device.ipv4address.publicPort" is set to PUBLICPORT
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV1

  @DeviceIdentifier_retrieve_identifier_200.04_success_scenario_3-legged_token_after_SIM_card_swap
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD2 with 3-legged access token
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And DEVICE1 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV1

  @DeviceIdentifier_retrieve_identifier_200.05_success_scenario_2-legged_token_after_SIM_card_swap
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD2 with 2-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And DEVICE1 is not identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER2
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV1

  @DeviceIdentifier_retrieve_identifier_200.06_success_scenario_3-legged_token_after_device_swap
  Scenario: Retrieve device identifier for DEVICE2 with SIM card SIMCARD1 with 3-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And DEVICE2 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI2
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV2

  @DeviceIdentifier_retrieve_identifier_200.07_success_scenario_2-legged_token_after_device_swap
  Scenario: Retrieve device identifier for DEVICE2 with SIM card SIMCARD1 with 2-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And DEVICE2 is not identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrieveIdentifier schema at "/components/schemas/200RetrieveIdentifier"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.imei" exists and is equal to IMEI2
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.imeisv", if present, is equal to IMEISV2

  # Generic 400 errors

    @device_identifier_retrieveIdentifier_400.1_schema_not_compliant
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the request body is set to any value which is not compliant with the schema at "/components/schemas/RequestBody"
        When the request "retrieveIdentifier" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @device_identifier_retrieveIdentifier_400.2_no_request_body
    Scenario: Missing request body
        Given the request body is not included
        When the request "retrieveIdentifier" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @device_identifier_retrieveIdentifier_400.3_device_empty
    Scenario: The device value is an empty object
        Given the request body property "$.device" is set to: {}
        When the request "retrieveIdentifier" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Note that device schema validation errors (if any) should be thrown even if a 3-legged access token is being used
    @device_identifier_retrieveIdentifier_400.4_device_identifiers_not_schema_compliant
    # Test every type of identifier even if not supported by the implementation
    Scenario Outline: Some device identifier value does not comply with the schema
        Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
        And a 2-legged or 3-legged access token is being used
        When the request "retrieveIdentifier" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

        Examples:
            | device_identifier          | oas_spec_schema                             |
            | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
            | $.device.ipv4Address       | /components/schemas/DeviceIpv4Addr          |
            | $.device.ipv6Address       | /components/schemas/DeviceIpv6Address       |
            | $.device.networkIdentifier | /components/schemas/NetworkAccessIdentifier |

    # The maximum is considered in the schema so a generic schema validator may fail and generate a 400 INVALID_ARGUMENT without further distinction, and both could be accepted
    @device_identifier_retrieveIdentifier_400.5_out_of_range_port
    Scenario: Out of range port
        Given the request body property  "$.device.ipv4Address.publicPort" is set to a value not between 0 and 65535
        When the request "retrieveIdentifier" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "OUT_OF_RANGE" or "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text
   
  @DeviceIdentifier_retrieve_identifier0_phoneNumber_does_not_match_schema
  Scenario Outline: phoneNumber value does not comply with the defined pattern
    Given the request body property "$.phoneNumber" is set to: <phone_number_value>
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | phone_number_value |
      | string_value       |
      | 1234567890         |
      | +12334foo22222     |
      | +00012230304913849 |
      | 123                |
      | ++49565456787      |
  
  @DeviceIdentifier_retrieve_identifier200_missing_device_information
  Scenario:  retrieve identifier but 2-legged access token used and no device information in request
    Given the correct base url for the API provider is used
    And the resource is "/retrieve-identifier"
    And a 2-legged access token is used
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And there is no request body
    Then the response status code is 400
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "DEVICE_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieve_identifier201_missing_scope
  Scenario:  retrieve device identifier with valid access token but scope device-identifier:retrieve-identifier is missing
    Given the correct base url for the API provider is used
    And the resource is "/retrieve-identifier"
    And none of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And the request body has the field phoneNumber with a value of PHONENUMBER1
    Then the response status code is 401
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" is "Request not authenticated due to missing, invalid, or expired credentials."

  @DeviceIdentifier_retrieve_identifier202_expired_access_token
  Scenario:  retrieve device identifier with expired access token
    Given the correct base url for the API provider is used
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    And the access token has expired
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And the request body has the field phoneNumber with a value of PHONENUMBER1
    Then the response status code is 401
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "AUTHENTICATION_REQUIRED"
    And the response property "$.message" is "New authentication is required."

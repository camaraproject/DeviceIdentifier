  @device-identifier-retrievePPID
  Feature: Camara Mobile Device Identifer API, vwip - Operation: retrievePPID

  # Input to be provided by the implementation to the tests
  # References to OAS spec schemas refer to schemas specified in /code/API_definitions/device-identifier.yaml
  # Implementation indications:
  # * api_root: API root of the server URL
  #
  # Testing assets:
  # * A mobile device "DEVICE1" with the folowing parameter values:
  #         | Parameter           | Value             | Comment                          |
  #         |---------------------|-------------------|----------------------------------|
  #         | IMEISV              | IMEISV1           |                                  |
  #         | IMEI                | IMEI1             |                                  |
  #         | TAC                 | TAC1              |                                  |
  #         | Manufacturer        | MANUFACTURER1     |                                  |
  #         | Model               | MODEL1            |                                  |
  #         | Public IPv4 Address | PUBLICIPV4ADDRESS |                                  |
  #         | Public Port         | PUBLICPORT        |                                  |
  #         | PPID                | PPID1             | API Provider dependent parameter |
  # * A mobile device "DEVICE2" with the folowing parameter values:
  #         | Parameter           | Value             | Comment                          |
  #         |---------------------|-------------------|----------------------------------|
  #         | IMEISV              | IMEISV2           |                                  |
  #         | IMEI                | IMEI2             |                                  |
  #         | TAC                 | TAC2              |                                  |
  #         | Manufacturer        | MANUFACTURER2     |                                  |
  #         | Model               | MODEL2            |                                  |
  #         | PPID                | PPID2             | API Provider dependent parameter |
  # * A SIM card "SIMCARD1" from "TELCO1" and phone number "PHONENUMBER1"
  # * A SIM card "SIMCARD2" from "TELCO2" and phone number "PHONENUMBER2"

  Background: Common Device Identifier retrievePPID setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/retrieve-ppid"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the RequestBody schema defined by "/components/schemas/RequestBody"

  # Success scenarios

  @DeviceIdentifier_retrievePPID_200.01_success_scenario_3-legged_token
  Scenario: Retrieve device PPID for DEVICE1 with SIM card SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.02_success_scenario_2-legged_token_identifying_device_by_phone_number
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD1 identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.03_success_scenario_2-legged_token_identifying_device_by_IPv4_address
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD1 identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.ipv4address.publicAddress" is set to PUBLICIPV4ADDRESS
    And request property "$.device.ipv4address.publicPort" is set to PUBLICPORT
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.04_success_scenario_3-legged_token_after_SIM_card_swap
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD2 using 3-legged access token
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And SIMCARD2 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.05_success_scenario_2-legged_token_after_SIM_card_swap
  Scenario: Retrieve device identifier for DEVICE1 with SIM card SIMCARD2 using 2-legged access token
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER2
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.06_success_scenario_3-legged_token_after_device_swap
  Scenario: Retrieve device identifier for DEVICE2 with SIM card SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And SIMCARD1 is identified by the access token
    And request property "$.device" does not exist
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID2
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.07_success_scenario_2-legged_token_after_device_swap
  Scenario: Retrieve device identifier for DEVICE2 with SIM card SIMCARD1 using 2-legged access token
    Given SIMCARD1 is installed within DEVICE2, which is connected to the network
    And no subject is identified by the access token
    And request property "$.device.phoneNumber" is set to PHONENUMBER1
    And one of the scopes associated with the access token is device-identifier:retrieve-ppid
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response body complies with the 200RetrievePPID schema at "/components/schemas/200RetrievePPID"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.ppid" exists and is equal to PPID2
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  # Generic 400 errors

  @DeviceIdentifier_retrievePPID_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is set to any value which is not compliant with the schema at "/components/schemas/RequestBody"
    When the request "retrievePPID" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "retrievePPID" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.3_device_empty
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the request "retrievePPID" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.4_device_identifiers_not_schema_compliant
  # Test every type of identifier even if not supported by the implementation
  # Note that device schema validation errors (if any) should be thrown even if a 3-legged access token is being used
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    And a 2-legged or 3-legged access token is being used
    When the request "retrievePPID" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                             |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber             |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr          |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address       |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier |

  # The maximum is considered in the schema so a generic schema validator may fail and generate a 400 INVALID_ARGUMENT without further distinction, and both could be accepted
  @DeviceIdentifier_retrievePPID_400.5_out_of_range_port
  Scenario: Out of range port
    Given the request body property  "$.device.ipv4Address.publicPort" is set to a value not between 0 and 65535
    When the request "retrievePPID" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE" or "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @DeviceIdentifier_retrievePPID_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "retrievePPID" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @DeviceIdentifier_retrievePPID_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "retrievePPID" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "retrievePPID" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 errors

  @DeviceIdentifier_retrievePPID_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope device-identifier:retrieve-ppid
    When the request "retrievePPID" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Generic 404 errors

  # Typically with a 2-legged access token when the identified device is managed by a different API provider
  @DeviceIdentifier_retrievePPID_404.1_device_not_found
  Scenario: An identifier cannot be matched to a valid device
    Given that the device cannot be identified from the access token
    And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    When the request "retrievePPID" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 422 errors

  @DeviceIdentifier_retrievePPID_422.1_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the request "retrievePPID" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_422.2_device_not_supported
  Scenario: Service not available for the device
    Given that service is not supported for all devices commercialized by the operator
    And the service is not applicable for the device identified by the token or provided in the request body
    When the request "retrievePPID" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  # Typically with a 2-legged access token
  @DeviceIdentifier_retrievePPID_422.3_unidentifiable_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a device
    And the request body property "$.device" is not included
    When the request "retrievePPID" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  # Typically with a 3-legged access token
  @DeviceIdentifier_retrievePPID_422.4_device_token_mismatch
  Scenario: Inconsistent access token context for the device
    # To test this, a token has to be obtained for a different device
    Given the request body property "$.device" is set to a valid testing device
    And the header "Authorization" is set to a valid access token obtained for a different device
    When the request "retrievePPID" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  # Typically with a 3-legged access token
  @DeviceIdentifier_retrievePPID_422.5_unnecessary_device_identifier_in_request
  Scenario: Explicit device identifier provided when device is identified by the access token
    Given the request body property "$.device" is set to a valid testing device
    And the header "Authorization" is set to a valid access token for that same device
    When the request "retrievePPID" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

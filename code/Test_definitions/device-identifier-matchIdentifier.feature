# device-identifier
# Feature: CAMARA Mobile Device Identifier API, vwip
# Operations: retrieveIdentifier | retrieveType | retrievePPID

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in /code/API_definitions/device-identifier.yaml
#
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
#         | Model               | MODEL1             |
#         | Manufacturer        | MANUFACTURER1      |
#         | PPID                | PPID1              |
#         | Public IPv4 Address | PUBLICIPV4ADDRESS1 |
#         | Public Port         | PUBLICPORT1        |
#
# * A mobile device "DEVICE2" with the following parameter values:
#         | Parameter           | Value              |
#         |---------------------|--------------------|
#         | IMEISV              | IMEISV2            |
#         | IMEI                | IMEI2              |
#         | TAC                 | TAC2               |
#         | Model               | MODEL2             |
#         | Manufacturer        | MANUFACTURER2      |
#         | PPID                | PPID2              |
#         | Public IPv4 Address | PUBLICIPV4ADDRESS2 |
#         | Public Port         | PUBLICPORT2        |
#
# * A SIM card "SIMCARD1" from "TELCO1" with phone number "PHONENUMBER1"
# * A SIM card "SIMCARD2" from "TELCO2" with phone number "PHONENUMBER2"
# * A fixed line or unsupported line identifier "UNSUPPORTED_LINE"

###############################################################################
# Feature: POST /retrieve-identifier
###############################################################################

Feature: CAMARA Device Identifier API - retrieveIdentifier

  Background: Common retrieveIdentifier setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/retrieve-identifier"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the RequestBody schema defined at "#/components/schemas/RequestBody"
    And one of the scopes associated with the access token is "device-identifier:retrieve-identifier"

  # ---------------------------------------------------------------------------
  # Success scenarios – 200
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_200.01_3legged_token
  Scenario: Retrieve identifier for DEVICE1 with SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveIdentifier"
    And the response property "$.imei" exists and equals IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" does not exist

  @DeviceIdentifier_retrieveIdentifier_200.02_2legged_token_by_phone_number
  Scenario: Retrieve identifier for DEVICE1 with SIMCARD1 using 2-legged token identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveIdentifier"
    And the response property "$.imei" exists and equals IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrieveIdentifier_200.03_2legged_token_by_ipv4_address
  Scenario: Retrieve identifier for DEVICE1 with SIMCARD1 using 2-legged token identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveIdentifier"
    And the response property "$.imei" exists and equals IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrieveIdentifier_200.04_2legged_token_by_multiple_identifiers
  Scenario: Retrieve identifier for DEVICE1 using 2-legged token with multiple device identifiers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveIdentifier"
    And the response property "$.imei" exists and equals IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" exists and contains exactly one device identifier property

  @DeviceIdentifier_retrieveIdentifier_200.05_optional_imeisv_returned
  Scenario: Response optionally includes imeisv when available
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.imei" exists and equals IMEI1
    And if the response property "$.imeisv" exists then it equals IMEISV1

  @DeviceIdentifier_retrieveIdentifier_200.06_optional_tac_model_manufacturer_returned
  Scenario: Response optionally includes tac, model and manufacturer when available
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.imei" exists
    And if the response property "$.tac" exists then it equals TAC1
    And if the response property "$.model" exists then it is a non-empty string
    And if the response property "$.manufacturer" exists then it is a non-empty string

  @DeviceIdentifier_retrieveIdentifier_200.07_after_sim_swap
  Scenario: Retrieve identifier reflects current device after SIM swap
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.imei" exists and equals IMEI1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  # ---------------------------------------------------------------------------
  # 400 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_400.01_schema_not_compliant
  Scenario: Invalid Argument - request body does not comply with schema
    Given the request body is set to any value which is not compliant with the schema at "#/components/schemas/RequestBody"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_400.03_device_empty_object
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_400.04_device_identifier_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                              |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber              |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr           |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address        |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier  |

  # ---------------------------------------------------------------------------
  # 401 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_401.01_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_401.02_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_401.03_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 403 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_403.01_missing_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "device-identifier:retrieve-identifier"
    When the HTTPS "POST" request is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 404 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_404.01_device_not_found
  Scenario: Device object does not identify a valid device
    Given that the device cannot be identified from the access token
    And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    When the HTTPS "POST" request is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 422 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveIdentifier_422.01_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_422.02_service_not_applicable
  Scenario: Service not applicable for the identified mobile device subscription
    Given the identified subject is a fixed line or otherwise unsupported subscription type
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_422.03_missing_identifier
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid 2-legged access token which does not identify a device
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_422.04_unnecessary_identifier_different_device
  Scenario: Device object provided but access token identifies a different device
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE2
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveIdentifier_422.05_unnecessary_identifier_same_device
  Scenario: Device object provided even though device is already identified by the 3-legged access token
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE1
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text


###############################################################################
# Feature: POST /retrieve-type
###############################################################################

Feature: CAMARA Device Identifier API - retrieveType

  Background: Common retrieveType setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/retrieve-type"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the RequestBody schema defined at "#/components/schemas/RequestBody"
    And one of the scopes associated with the access token is "device-identifier:retrieve-type"

  # ---------------------------------------------------------------------------
  # Success scenarios – 200
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_200.01_3legged_token
  Scenario: Retrieve device type for DEVICE1 with SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveType"
    And the response property "$.tac" exists and equals TAC1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" does not exist

  @DeviceIdentifier_retrieveType_200.02_2legged_token_by_phone_number
  Scenario: Retrieve device type for DEVICE1 using 2-legged token identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveType"
    And the response property "$.tac" exists and equals TAC1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrieveType_200.03_2legged_token_by_ipv4_address
  Scenario: Retrieve device type for DEVICE1 using 2-legged token identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveType"
    And the response property "$.tac" exists and equals TAC1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrieveType_200.04_2legged_token_by_multiple_identifiers
  Scenario: Retrieve device type for DEVICE1 using 2-legged token with multiple device identifiers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrieveType"
    And the response property "$.tac" exists and equals TAC1
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" exists and contains exactly one device identifier property

  @DeviceIdentifier_retrieveType_200.05_optional_model_manufacturer_returned
  Scenario: Response optionally includes model and manufacturer when available
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.tac" exists
    And if the response property "$.model" exists then it is a non-empty string
    And if the response property "$.manufacturer" exists then it is a non-empty string

  @DeviceIdentifier_retrieveType_200.06_after_sim_swap
  Scenario: Retrieve type reflects current device after SIM swap
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.tac" exists and equals TAC1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  # ---------------------------------------------------------------------------
  # 400 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_400.01_schema_not_compliant
  Scenario: Invalid Argument - request body does not comply with schema
    Given the request body is set to any value which is not compliant with the schema at "#/components/schemas/RequestBody"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_400.03_device_empty_object
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_400.04_device_identifier_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                              |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber              |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr           |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address        |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier  |

  # ---------------------------------------------------------------------------
  # 401 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_401.01_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_401.02_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_401.03_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 403 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_403.01_missing_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "device-identifier:retrieve-type"
    When the HTTPS "POST" request is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 404 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_404.01_device_not_found
  Scenario: Device object does not identify a valid device
    Given that the device cannot be identified from the access token
    And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    When the HTTPS "POST" request is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 422 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrieveType_422.01_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_422.02_service_not_applicable
  Scenario: Service not applicable for the identified mobile device subscription
    Given the identified subject is a fixed line or otherwise unsupported subscription type
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_422.03_missing_identifier
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid 2-legged access token which does not identify a device
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_422.04_unnecessary_identifier_different_device
  Scenario: Device object provided but access token identifies a different device
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE2
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieveType_422.05_unnecessary_identifier_same_device
  Scenario: Device object provided even though device is already identified by the 3-legged access token
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE1
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text


###############################################################################
# Feature: POST /retrieve-ppid
###############################################################################

Feature: CAMARA Device Identifier API - retrievePPID

  Background: Common retrievePPID setup
    Given an environment at "apiRoot"
    And the resource "/device-identifier/vwip/retrieve-ppid"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is compliant with the RequestBody schema defined at "#/components/schemas/RequestBody"
    And one of the scopes associated with the access token is "device-identifier:retrieve-ppid"

  # ---------------------------------------------------------------------------
  # Success scenarios – 200
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_200.01_3legged_token
  Scenario: Retrieve PPID for DEVICE1 with SIMCARD1 using 3-legged access token
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrievePPID"
    And the response property "$.ppid" exists and is a non-empty string
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" does not exist

  @DeviceIdentifier_retrievePPID_200.02_2legged_token_by_phone_number
  Scenario: Retrieve PPID for DEVICE1 using 2-legged token identifying device by phone number
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrievePPID"
    And the response property "$.ppid" exists and is a non-empty string
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.03_2legged_token_by_ipv4_address
  Scenario: Retrieve PPID for DEVICE1 using 2-legged token identifying device by IPv4 address
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrievePPID"
    And the response property "$.ppid" exists and is a non-empty string
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  @DeviceIdentifier_retrievePPID_200.04_2legged_token_by_multiple_identifiers
  Scenario: Retrieve PPID for DEVICE1 using 2-legged token with multiple device identifiers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER1
    And the request body property "$.device.ipv4Address.publicAddress" is set to PUBLICIPV4ADDRESS1
    And the request body property "$.device.ipv4Address.publicPort" is set to PUBLICPORT1
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the schema at "#/components/responses/200RetrievePPID"
    And the response property "$.ppid" exists and is a non-empty string
    And the response property "$.lastChecked" exists and is a valid date-time in the past
    And the response property "$.device" exists and contains exactly one device identifier property

  @DeviceIdentifier_retrievePPID_200.05_ppid_is_stable_per_consumer
  Scenario: PPID returned for the same device is consistent across calls for the same API consumer
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent for the first time
    And the HTTPS "POST" request is sent for the second time with the same access token
    Then both responses have status code 200
    And the response property "$.ppid" is equal in both responses

  @DeviceIdentifier_retrievePPID_200.06_ppid_differs_per_consumer
  Scenario: PPID returned for the same device differs between API consumers
    Given SIMCARD1 is installed within DEVICE1, which is connected to the network
    And SIMCARD1 is identified by the access token
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent using access token for API_CONSUMER_1
    And the HTTPS "POST" request is sent using access token for API_CONSUMER_2
    Then both responses have status code 200
    And the response property "$.ppid" is different between the two responses

  @DeviceIdentifier_retrievePPID_200.07_after_sim_swap
  Scenario: PPID reflects the physical device even after SIM swap
    Given SIMCARD2 is installed within DEVICE1, which is connected to the network
    And no subject is identified by the access token
    And the request body property "$.device.phoneNumber" is set to PHONENUMBER2
    When the HTTPS "POST" request is sent
    Then the response status code is 200
    And the response property "$.ppid" exists and equals PPID1
    And the response property "$.lastChecked" exists and is a valid date-time in the past

  # ---------------------------------------------------------------------------
  # 400 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_400.01_schema_not_compliant
  Scenario: Invalid Argument - request body does not comply with schema
    Given the request body is set to any value which is not compliant with the schema at "#/components/schemas/RequestBody"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.03_device_empty_object
  Scenario: The device value is an empty object
    Given the request body property "$.device" is set to: {}
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_400.04_device_identifier_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTPS "POST" request is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                              |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber              |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr           |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address        |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier  |

  # ---------------------------------------------------------------------------
  # 401 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_401.01_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_401.02_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_401.03_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the HTTPS "POST" request is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 403 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_403.01_missing_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "device-identifier:retrieve-ppid"
    When the HTTPS "POST" request is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 404 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_404.01_device_not_found
  Scenario: Device object does not identify a valid device
    Given that the device cannot be identified from the access token
    And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
    When the HTTPS "POST" request is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # ---------------------------------------------------------------------------
  # 422 errors
  # ---------------------------------------------------------------------------

  @DeviceIdentifier_retrievePPID_422.01_device_identifiers_unsupported
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some type of device identifiers are not supported by the implementation
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_422.02_service_not_applicable
  Scenario: Service not applicable for the identified mobile device subscription
    Given the identified subject is a fixed line or otherwise unsupported subscription type
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_422.03_missing_identifier
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid 2-legged access token which does not identify a device
    And the request body does not include the "device" property
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_422.04_unnecessary_identifier_different_device
  Scenario: Device object provided but access token identifies a different device
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE2
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrievePPID_422.05_unnecessary_identifier_same_device
  Scenario: Device object provided even though device is already identified by the 3-legged access token
    Given the header "Authorization" is set to a valid 3-legged access token for DEVICE1
    And the request body property "$.device" is set to identifiers that resolve to DEVICE1
    When the HTTPS "POST" request is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

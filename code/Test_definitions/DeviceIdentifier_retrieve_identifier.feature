@DeviceIdentifier_retrieve_identifier
Feature: Camara Device Identifer API retrieve identifier

# Input to be provided by the implementation to the tests
# References to OAS spec schemas refer to schemas specified in code/API_definitions/CAMARA Mobile Device Identifier API.yaml
# Implementation indications:
# * api_root: API root of the server URL
#
# Testing assets:
# * a mobile device with imei IMEI1 and phone number PHONENUMBER1
# * a mobile device with imei IMEISV2  and phone number PHONENUMBER2
# * a mobile device with imei IMEISV2, public IPv4 address PUBLICIPV4ADDRESS and public port PUBLICPORT

  Background: Common Device Identifier retrieve identifer setup
    Given the resource "/retrieve-identifier/v0"  as  base url
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is compliant with the schema Device
    
  @DeviceIdentifier_retrieve_identifier0_phoneNumber_does_not_match_schema
  Scenario Outline: phoneNumber value does not comply with the schema
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

  @DeviceIdentifier_retrieve_identifier100_success
  Scenario:  retrieve device identifer for phone number PHONENUMBER1, network connection and access token matches PHONENUMBER1
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the request body has the field phoneNumber with a value of PHONENUMBER1
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/200RetrieveIdentifier"
    Then the response status code is 200
    And the response property "$.imei" is IMEI1

  @DeviceIdentifier_retrieve_identifier101_success
  Scenario:  retrieve device identifer for phone number PHONENUMBER2, network connection and access token matches PHONENUMBER2
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the request body has the field phoneNumber with a value of PHONENUMBER2
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/200RetrieveIdentifier"
    Then the response status code is 200
    And the response property "$.imeisv" is IMEISV2

  @DeviceIdentifier_retrieve_identifier102_ipv4Address_success
  Scenario:  retrieve device identifer for phone number PHONENUMBER2, network connection and access token matches PHONENUMBER2
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the request body has the field ipv4Address with a value of IPV4ADDRESS
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/200RetrieveIdentifier"
    Then the response status code is 200
    And the response property "$.imeisv" is IMEISV2

  @DeviceIdentifier_retrieve_identifier200_missing_device_information
  Scenario:  retrieve identifier but no device information in request
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And the request body has NO the field phoneNumber nor other device information
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @DeviceIdentifier_retrieve_identifier201_missing_scope
  Scenario:  retrieve device identifier with valid access token but scope device-identifier:retrieve-identifier is missing
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And none of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And the request body has the field phoneNumber with a value of PHONENUMBER1
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" is "Request not authenticated due to missing, invalid, or expired credentials."

  @DeviceIdentifier_retrieve_identifier202_expired_access_token
  Scenario:  retrieve device identifier with expired access token
    Given they use the base url
    And the resource is "/retrieve-identifier"
    And one of the scopes associated with the access token is device-identifier:retrieve-identifier
    When the HTTPS "POST" request is sent
    And the connection the request is sent over originates from a device with PHONENUMBER1
    And the access token has expired
    And the request body has the field phoneNumber with a value of PHONENUMBER1
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorResponse"
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "AUTHENTICATION_REQUIRED"
    And the response property "$.message" is "New authentication is required."





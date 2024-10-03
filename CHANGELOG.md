# Changelog DeviceIdentifier

## Table of Contents
- **[r2.1](#r21)**
- [v0.1.0](#v010)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

# r2.1
## Release Notes

This public release contains the definition and documentation of
* device-identifier v0.2.0-alpha.1

The API definition(s) are based on
* Commonalities v0.4.0
* Identity and Consent Management v0.2.1

## quality-on-demand v0.2.0-alpha.1

Version 0.2.0-alpha.1 contains many small changes for compliance with Commonalities v0.4.0 and Identity and Consent Management v0.2.1. **There are breaking changes compared to v0.1.0.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r2.1/code/API_definitions/device-identifier.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r2.1/code/API_definitions/device-identifier.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceIdentifier/blob/r2.1/code/API_definitions/device-identifier.yaml)

### Added
* Create Device Identifier User Story.md by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/59
* Add EUDI Wallet and Mobile Device Insurance User Stories by @AxelNennker in https://github.com/camaraproject/DeviceIdentifier/pull/73
* Initial Test Definitions for DeviceIdentifier retrieve identifier by @AxelNennker in https://github.com/camaraproject/DeviceIdentifier/pull/72
* Add global tag definitions to OAS definition by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/83

### Changed
* Rename `X-Correlator` header to `x-correlator` by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/62
* Incorporate Commonalities WG recommendations on Simplification of Device object by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/64
* Reduce telco language in the API description by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/77
* Rewrite text around treatment of primary / secondary MSISDN by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/76
* Update `info` section of OAS to comply with Commonalities guidelines v0.4.0 by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/66
* Rename CAMARA Mobile Device Identifier API.yaml to device-identifier.yaml by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/84

### Fixed
* Fixes the missing `required` property in the the error response schema by @sfnuser in https://github.com/camaraproject/DeviceIdentifier/pull/75
* Remove `format: uuid` from x-correlator definition by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/67

### Removed
* Remove 405 error response from YAML by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/81

**Full Changelog**: https://github.com/camaraproject/DeviceIdentifier/compare/device-identifier-0.1.0...r2.1

# v0.1.0
## Release Notes

This pre-release contains the first initial version v0.1.0 of the Device Identifier API.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/device-identifier-0.1.0/code/API_definitions/CAMARA%20Mobile%20Device%20Identifier%20API.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/device-identifier-0.1.0/code/API_definitions/CAMARA%20Mobile%20Device%20Identifier%20API.yaml)
  - [OpenAPI YAML spec file](https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/device-identifier-0.1.0/code/API_definitions/CAMARA%20Mobile%20Device%20Identifier%20API.yaml)

- This pre-release is intended to be compliant with:
  - Commonalities Release [0.3.0](https://github.com/camaraproject/Commonalities/releases/tag/v0.3.0)
  - Identity and Consent Management Release [0.1.0](https://github.com/camaraproject/IdentityAndConsentManagement/releases/tag/v0.1.0)

# Main Changes
- New endpoint /retrieve-identifier to retrieve an identifier (IMEI) and other optional details for the device associated with a specified end user subscription (e.g. MSISDN)
- New endpoint /retrieve-type to retrieve the device type (TAC - Type Approval Code) and other optional details for the device associated with a specified end user subscription

# Added
- Added endpoint /retrieve-identifier added by @eric-murray in PR https://github.com/camaraproject/DeviceIdentifier/pull/55
- Added endpoint /retrieve-type added by @eric-murray in PR https://github.com/camaraproject/DeviceIdentifier/pull/55

# Changed
- Update README.MD by @Kevsy in PR https://github.com/camaraproject/DeviceIdentifier/pull/39

# Fixed
- Typo fixes by @deeokonkwo in PR https://github.com/camaraproject/DeviceIdentifier/pull/50

# Removed
- N/A

Full Changelog: https://github.com/camaraproject/DeviceIdentifier/commits/device-identifier-0.1.0
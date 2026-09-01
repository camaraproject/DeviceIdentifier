# Changelog DeviceIdentifier

<!-- TOC:START -->
## Table of Contents
- [r3.2](#r32)
- [r3.1](#r31)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r3.2

## Release Notes

This release candidate contains the definition and documentation of
* device-identifier 0.4.0-rc.1

The API definition(s) are based on
* Commonalities r4.3 (0.8.0)
* Identity and Consent Management r4.2 (0.5.0)

## device-identifier 0.4.0-rc.1

**device-identifier 0.4.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.3.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r3.2/code/API_definitions/device-identifier.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r3.2/code/API_definitions/device-identifier.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceIdentifier/blob/r3.2/code/API_definitions/device-identifier.yaml)

### Breaking changes

* Mandatory response property `lastChecked` can now be set to `null` if the API provider does not have this information

### Added

* Add match-identifier endpoint by @ALIIQBAL786 in https://github.com/camaraproject/DeviceIdentifier/pull/151
* Add common template code to info.description by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/170
* Add conformance test definitions for the new /match-identifier endpoint  by @usmanTheCoder in https://github.com/camaraproject/DeviceIdentifier/pull/160
* [Added] Update test cases for device identifier matching by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/188
* [Added] Add tests for multiple device identifiers and missing end user consent by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/205

### Changed

* fix: changed networkaccessidentifier example to use example.com by @Kevsy in https://github.com/camaraproject/DeviceIdentifier/pull/147
* Update API definition following Commonalities r4.3 by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/167
  * Use header, parameter and schema definition from Commonalities where possible rather than maintain local copies
  * Add `maxLength` directive for all strings
    * Free-form `model` and `manufacturer` strings now limited to 32 characters
  * Tightening of `ppid` format by adding `minLength: 64`, `maxLength: 128`, and `pattern: ^[a-fA-F0-9]{64,128}$` constraints
* [Changed] Update and clarify tests for applicability to 2-legged and/or 3-legged access tokens by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/189
* [Changed] Make lastChecked property nullable and add examples by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/184
* [Changed] Various documentation additions, updates and fixes for consistency, accuracy and clarity by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/198
* [Changed] Add dedicated response body schema and update tests by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/203
* [Changed] Refactor MatchRequestBody‎ to allow proper schema validation for provided identifier by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/202

### Fixed

* Fix typo in test scenario 200.05 by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/155
* [Fixed] Fix ipv4Address typo in feature files by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/182
* [Fixed] Rename schema DevicePPID to use PascalCase by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/179
* [Fixed] Fix test definition component references by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/197
* [Fixed] Fix examples by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/196
* [Fixed] Documentation fixes by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/204

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/DeviceIdentifier/compare/r2.2...r3.2

# r3.1

## Release Notes

This pre-release contains the definition and documentation of
* device-identifier 0.4.0-alpha.1

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## device-identifier 0.4.0-alpha.1

**device-identifier 0.4.0-alpha.1 is an alpha version of this API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r3.1/code/API_definitions/device-identifier.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/DeviceIdentifier/r3.1/code/API_definitions/device-identifier.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/DeviceIdentifier/blob/r3.1/code/API_definitions/device-identifier.yaml)

### Added

* Add match-identifier endpoint by @ALIIQBAL786 in https://github.com/camaraproject/DeviceIdentifier/pull/151
* Add common template code to info.description by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/170

### Changed

* fix: changed networkaccessidentifier example to use example.com by @Kevsy in https://github.com/camaraproject/DeviceIdentifier/pull/147

### Fixed

* Fix typo in test scenario 200.05 by @eric-murray in https://github.com/camaraproject/DeviceIdentifier/pull/155

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/DeviceIdentifier/compare/r2.2...r3.1


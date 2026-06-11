# Changelog DeviceIdentifier

<!-- TOC:START -->
## Table of Contents
- [r3.1](#r31)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

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


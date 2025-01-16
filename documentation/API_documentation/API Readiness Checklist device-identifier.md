# API Readiness Checklist

Checklist for device-identifier v0.2.0-rc.1 in r1.2.

| Nr | API release assets  | alpha | release-candidate |  initial<br>public | stable<br> public | Status  | Comments                                                               |
|----|----------------------------------------------|:-----:|:-----------------:|:-------:|:------:|:----:|:----------------------------------------------------------------------:|
|  1 | API definition                               |   M   |         M         |    M    |    M   |  Y   | [device-identifier.yaml](/code/API_definitions/device-identifier.yaml) |
|  2 | Design guidelines from Commonalities applied |   O   |         M         |    M    |    M   |  Y   | 0.5.0-alpha.1                                                          |
|  3 | Guidelines from ICM applied                  |   O   |         M         |    M    |    M   |  Y   | 0.3.1-alpha.1                                                          |
|  4 | API versioning convention applied            |   M   |         M         |    M    |    M   |  Y   | 0.2.0-rc.1                                                             |
|  5 | API documentation                            |   M   |         M         |    M    |    M   |  Y   | Inline in OAS definition                                               |
|  6 | User stories                                 |   O   |         O         |    O    |    M   |  Y   | [Device Identifier User Story.md](/documentation/API_documentation/Device%20Identifier%20User%20Story.md) |
|  7 | Basic API test cases & documentation         |   O   |         M         |    M    |    M   |  Y   | [device-identifier-retrieveIdentifier.feature](/code/Test_definitions/device-identifier-retrieveIdentifier.feature)<br>[device-identifier-retrieveType.feature](/code/Test_definitions/device-identifier-retrieveType.feature) |
|  8 | Enhanced API test cases & documentation      |   O   |         O         |    O    |    M   |  N   |                                                                        |
|  9 | Test result statement                        |   O   |         O         |    O    |    M   |  N   |                                                                        |
| 10 | API release numbering convention applied     |   M   |         M         |    M    |    M   |  Y   | r1.2                                                                   |
| 11 | Change log updated                           |   M   |         M         |    M    |    M   |  Y   | [CHANGELOG.md](/CHANGELOG.md)                                          |
| 12 | Previous public release was certified        |   O   |         O         |    O    |    M   |  N   |                                                                        |

To fill the checklist:
- in the line above the table, replace the api-name, api-version and the rx.y by their actual values for the current API version and release.
- in the Status column, put "Y" (yes) if the release asset is available or fulfilled in the current release, a "N" (no) or a "tbd". Example use of "tbd" is in case an alpha or release-candidate API version does not yet provide all mandatory assets for the release.
- in the Comments column, provide the link to the asset once available, and any other relevant comments.

Note: the checklists of a public API version and of its preceding release-candidate API version can be the same.

The documentation for the content of the checklist is here: [API Readiness Checklist](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14559630/API+Release+Process#API-readiness-checklist).

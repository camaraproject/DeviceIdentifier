# Device Identifier API User Story

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an application developer belonging to an enterprise, I want my application server to be able to request the identity of the mobile device (represented by the IMEI) currently being used by a given mobile network subscriber (identified by MSISDN, IP address or, when supported by network operators, a Network Access Identifier). Optionally, I'd like to know the make and model of that device. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User<br> **Actors:** Application Service Providers, Hyperscalers, Application Developers, End Users<br> **Scope:** *Order To Activate (OTA)* \- Retrieve device identifier details |
| ***Pre-Conditions*** |The preconditions are listed below:<br><ol><li>The Customer:BusinessManager and Customer:Administrator have been onboarded to the CSP's API platform.</li><li>The Customer:BusinessManager has successfully subscribed to the Device Identifier product from the product catalog.</li><li>The Customer:Administrator has onboarded the Customer:User to the platform.</li><li>The Customer:BusinessManager has agreed to the terms and conditions of the CSP for managing consent of mobile subscription owners.</li><li>The means to get the access token are known to the Customer:User to ensure secure access of the API.|
| ***Activities/Steps*** | **Starts when:** The Customer:User's application server makes a POST request to the Device Identifier API containing the end user's subscription information in the request body in order to retrieve the device identifier plus any optional device information.<br>**Ends when:** The Device Identifier API returns the requested information, or an error message |
| ***Post-Conditions*** | None  |
| ***Exceptions*** | Several exceptions might occur after a request to the Device Identifier API<br>- **Unauthorized**: Invalid credentials (e.g. use of already expired access token).<br>- **Invalid Input**: Invalid input data to retrieve device details (e.g. MSISDN format not as expected, or MSISDN not associated with a customer of the CSP).<br>- **Forbidden**: End user has not consented to device identifier information being provided to the Customer:User|

# EUDI Wallet Device-Binding User Story

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an application developer working for an EUDI Wallet provider, I want to bind the user's wallet to their device. For that purpose I want to retrieve the device identifier of the user's device. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User<br> **Actors:** Application Service Providers, Hyperscalers, Application Developers, End Users<br> **Scope:** *Order To Activate (OTA)* \- Retrieve device identifier details |
| ***Pre-Conditions*** |The preconditions are listed below:<br><ol><li>The Customer:BusinessManager and Customer:Administrator have been onboarded to the CSP's API platform.</li><li>The Customer:BusinessManager has successfully subscribed to the Device Identifier product from the product catalog.</li><li>The Customer:Administrator has onboarded the Customer:User to the platform.</li><li>The Customer:BusinessManager has agreed to the terms and conditions of the CSP for managing consent of mobile subscription owners.</li><li>The means to get the access token are known to the Customer:User to ensure secure access of the API.|
| ***Activities/Steps*** | **Starts when:** The Customer:User has installed the EUDI Wallet and the wallet runs for the first time. The EUDI Wallet retrieves an access-token using OIDC authentication code flow and creates a POST request to the DeviceIdentifier API to retrieve the device identifer.<br>**Ends when:** The Device Identifier API returns the requested information, or an error message |
| ***Post-Conditions*** | None  |
| ***Exceptions*** | Several exceptions might occur after a request to the Device Identifier API<br>- **Unauthorized**: Invalid credentials (e.g. use of already expired access token).<br>- **Invalid Input**: Invalid input data to retrieve device details (e.g. MSISDN format not as expected, or MSISDN not associated with a customer of the CSP).<br>- **Forbidden**: End user has not consented to device identifier information being provided to the Customer:User|

# Device Type API User Story

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an application developer belonging to an enterprise, I want my application server to be able to request details about the type of the mobile device (represented by the Type Approval Code - TAC) currently being used by a given mobile network subscriber (identified by MSISDN, IP address or, when supported by network operators, a Network Access Identifier). Optionally, I'd like to know the make and model of that device. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User<br> **Actors:** Application Service Providers, Hyperscalers, Application Developers, End Users<br> **Scope:** *Order To Activate (OTA)* \- Retrieve device type details |
| ***Pre-Conditions*** |The preconditions are listed below:<br><ol><li>The Customer:BusinessManager and Customer:Administrator have been onboarded to the CSP's API platform.</li><li>The Customer:BusinessManager has successfully subscribed to the Device Type product from the product catalog.</li><li>The Customer:Administrator has onboarded the Customer:User to the platform.</li><li>The Customer:BusinessManager has agreed to the terms and conditions of the CSP for managing consent of mobile subscription owners.</li><li>The means to get the access token are known to the Customer:User to ensure secure access of the API.|
| ***Activities/Steps*** | **Starts when:** The Customer:User's application server makes a POST request to the Device Type API containing the end user's subscription information in the request body in order to retrieve the device TAC plus any optional device information.<br>**Ends when:** The Device Type API returns the requested information, or an error message |
| ***Post-Conditions*** | None  |
| ***Exceptions*** | Several exceptions might occur after a request to the Device Type API<br>- **Unauthorized**: Invalid credentials (e.g. use of already expired access token).<br>- **Invalid Input**: Invalid input data to retrieve device details (e.g. MSISDN format not as expected, or MSISDN not associated with a customer of the CSP).<br>- **Forbidden**: End user has not consented to device TAC information being provided to the Customer:User|

# Mobile Device Insurance User Story

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an application developer working for an insurance company that insures mobile devices, I want to retrieve the device identifier and the model and make of the user's device. The retrieved information is used in creating the contract between the insurance company and the user, and also when the user reports the device to be e.g. damaged or stolen. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User<br> **Actors:** Application Service Providers, Hyperscalers, Application Developers, End Users<br> **Scope:** *Order To Activate (OTA)* \- Retrieve device type details |
| ***Pre-Conditions*** |The preconditions are listed below:<br><ol><li>The Customer:BusinessManager and Customer:Administrator have been onboarded to the CSP's API platform.</li><li>The Customer:BusinessManager has successfully subscribed to the Device Type product from the product catalog.</li><li>The Customer:Administrator has onboarded the Customer:User to the platform.</li><li>The Customer:BusinessManager has agreed to the terms and conditions of the CSP for managing consent of mobile subscription owners.</li><li>The means to get the access token are known to the Customer:User to ensure secure access of the API.|
| ***Activities/Steps*** | **Starts when:** The Customer:Applicatoin requests an access token using OIDC authorization code flow and then uses the DeviceIdentifier API to retrieve device identifier and model and make of the user's devive.<br>**Ends when:** The Device Type API returns the requested information, or an error message |
| ***Post-Conditions*** | None  |
| ***Exceptions*** | Several exceptions might occur after a request to the Device Type API<br>- **Unauthorized**: Invalid credentials (e.g. use of already expired access token).<br>- **Invalid Input**: Invalid input data to retrieve device details (e.g. MSISDN format not as expected, or MSISDN not associated with a customer of the CSP).<br>- **Forbidden**: End user has not consented to device TAC information being provided to the Customer:User|


# dlvn-sdk-android

EDR - DLVN Android SDK 

Latest version: 1.0.14 (Updated: 10/11/2023)

## Version 1.0.14
- handle event back click + share from dlvn
- disable zoom in webview

## Version 1.0.13
- update function to clearWebViewCache call when logout app
- WebView is now able to perform: User (not logged in) types his question, then hits "Submit" -> back to DC app to request login but save current form data in WebView.

## Version 1.0.12
- Addding logOutWebView function
- token is now a required field in JSONObject of DLVNSendData function

## Version 1.0.11
- Changing flow of login case 2: Using DC app's login module
- Adding setOnSdkRequestLogin function

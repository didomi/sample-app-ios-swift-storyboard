#  Didomi - iOS Sample App (Swift)

## Description

**This sample app demonstrates how to implement Didomi in a simple Xcode project using Swift.**

In particular, it shows how to:
* Condition a custom vendor to consent
* Open the Preferences
* Share consent with a web view

This app is also using the Google Mobile Ads SDK as we are taking Google Advertising Products as an example of a commonly used IAB vendor.

## Content

**AppDelegate**

* Initialize the Didomi SDK.
* Initialize the Google Mobile Ads SDK. The consent status is shared with Google automatically as it is an IAB vendor.
* Condition a custom vendor to consent. We initialize it if and only if it is enabled.

**ViewController**

Here we define the actions of the buttons of our UI:
* Show the preferences (purposes).
* Show the preferences (vendors).
* Show a web view.
* Show an ad.

**WebViewController**

* Load a WKWebView and share consent with it. You need to embed the Didomi Web SDK in the HTML page that is loaded by the web view so that it can collect the consent information passed from the app and share it with vendors. The list of vendors configured in the web SDK in the web view should be a subset of the list of vendors configured in the mobile app. That will ensure that the WebView has all the consent information it needs and does not re-collect consent. See [Share consent with WebViews](https://developers.didomi.io/cmp/mobile-sdk/share-consent-with-webviews).

**CustomVendor**

* Implement a basic `CustomVendor` class with an `initialize()` method to simulate our custom vendor's SDK.


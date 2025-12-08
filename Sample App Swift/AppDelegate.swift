//
//  AppDelegate.swift
//  Sample App Swift
//

import UIKit
import Didomi
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var didomiEventListener: EventListener?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let parameters = DidomiInitializeParameters(
            apiKey: "7dd8ec4e-746c-455e-a610-99121b4148df", // Replace with your API key
            localConfigurationPath: nil,
            remoteConfigurationURL: nil,
            providerID: nil,
            disableDidomiRemoteConfig: false,
            noticeID: "DVLP9Qtd" // Replace with your notice ID, or remove if using domain targeting
        )
        
        // Initialize the SDK
        Didomi.shared.initialize(parameters)
        
        // Important: views should not wait for onReady to be called.
        // You might want to execute code here that needs the Didomi SDK
        // to be initialized such as: analytics and other non-IAB vendors.
        Didomi.shared.onReady {
            // The Didomi SDK is ready to go, you can call other functions on the SDK
            [weak self] in
            
            // Load your custom vendors in the onReady callback.
            // These vendors need to be conditioned manually to the consent status of the user.
            Task { @MainActor in
                self?.loadVendor()
            }
        }
        
        // Load the IAB vendors; the consent status will be shared automatically with them.
        // Regarding the Google Mobile Ads SDK, we also delay App Measurement as described here:
        // https://developers.google.com/admob/ios/eu-consent#delay_app_measurement_optional
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func loadVendor() {
        
        let vendorId = "customven-gPVkJxXD"
        let didomi = Didomi.shared
        let status = didomi.getCurrentUserStatus()
        let isVendorEnabled = status.vendors[vendorId]?.enabled ?? false
        
        // Remove any existing event listener
        if let eventListener = didomiEventListener {
            didomi.removeEventListener(listener: eventListener)
        }
        
        if (isVendorEnabled) {
            // We have consent for the vendor
            // Initialize the vendor SDK
            CustomVendor.shared.initialize()
        } else {
            // We do not have consent information yet
            // Wait until we get the user information
            didomiEventListener = EventListener()
            didomiEventListener!.onConsentChanged = { [weak self] event in
                self?.loadVendor()
            }
            didomi.addEventListener(listener: didomiEventListener!)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


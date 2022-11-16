//
//  ViewController.swift
//  Sample App Swift
//

import UIKit
import Didomi
import AppTrackingTransparency
import GoogleMobileAds

class ViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBAction func showPreferencesPurposes(_ sender: UIButton) {
        Didomi.shared.onReady {
            Didomi.shared.showPreferences()
        }
    }
    
    @IBAction func showPreferencesVendors(_ sender: UIButton) {
        Didomi.shared.onReady {
            Didomi.shared.showPreferences(controller: self, view: .vendors)
        }
    }
    
    @IBAction func showAd(_ sender: UIButton) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
          } else {
            print("Didomi Sample App - Ad wasn't ready")
          }
    }
    
    private var interstitial: GADInterstitialAd?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 14, *) {
            // Here we show the Didomi notice after the ATT prompt whatever the ATT status.
            // You may want to do the following instead:
            // - Show the CMP notice then the ATT permission if the user gives consent in the CMP notice (https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-cmp-notice-then-the-att-permission-if-the-user-gives-consent-in-the-cmp-notice)
            // - Show the ATT permission then the CMP notice if the user accepts the ATT permission (https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-att-permission-then-the-cmp-notice-if-the-user-accepts-the-att-permission)
            ATTrackingManager.requestTrackingAuthorization { status in
                // Show the Didomi CMP notice to collect consent from the user
                Didomi.shared.setupUI(containerController: self)
            }
        } else {
            // Show the Didomi CMP notice to collect consent from the user as iOS < 14 (no ATT available)
            Didomi.shared.setupUI(containerController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Didomi.shared.onReady {
            self.loadAd()
            
            let didomiEventListener = EventListener()
            didomiEventListener.onConsentChanged = { event in
                // The consent status of the user has changed
                self.loadAd()
            }
            Didomi.shared.addEventListener(listener: didomiEventListener)
        }
    }
    
    /**
     * Will reset / preload Ad after each consent change
     * Consent allows Ads: the ad cache will be prepared (ad is displayed on first click after reject -> accept)
     * Consent rejects Ads: the ad chache will be purged (no ad on first click after reject)
     */
    private func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                interstitial = nil // will reset the cached ad (when error is `No ad to show`)
                print("Didomi Sample App - Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Didomi Sample App - Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Didomi Sample App - Ad will present full screen content.")
        interstitial = nil
        loadAd()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Didomi Sample App - Ad did dismiss full screen content.")
    }
    
}


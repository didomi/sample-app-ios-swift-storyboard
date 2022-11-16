//
//  WebviewController.swift
//  Sample App Swift
//

import Foundation
import UIKit
import WebKit
import Didomi

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var webView: WKWebView!
    
    override func loadView() {
        
        // Configure the web view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The notice should automatically get hidden in the web view as consent is passed from the mobile app to the website. However, it might happen that the notice gets displayed for a very short time before being hidden. You can disable the notice in your web view to make sure that it never shows by appending didomiConfig.notice.enable=false to the query string of the URL that you are loading
        let myURL = URL(string:"https://didomi.github.io/webpage-for-sample-app-webview/?didomiConfig.notice.enable=false")!
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
        // Inject consent information into the web view
        Didomi.shared.onReady { [weak self] in
            let string = Didomi.shared.getJavaScriptForWebView()
            let script = WKUserScript(source: string, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            self?.webView.configuration.userContentController.addUserScript(script)
        }
    }
}

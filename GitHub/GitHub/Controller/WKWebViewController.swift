//
//  WKWebViewController.swift
//  GitHub
//
//  Created by Rafael Escaleira on 15/01/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    @IBOutlet weak var wkWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = GitHubAPIV4.getURL() else { return }
        self.wkWebView.navigationDelegate = self
        self.wkWebView.load(URLRequest(url: url))
        self.wkWebView.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func reloadButtonAction(_ sender: UIBarButtonItem) {
        
        guard let url = GitHubAPIV4.getURL() else { return }
        self.wkWebView.load(URLRequest(url: url))
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        
        DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
    }
}

extension WKWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
        if navigationAction.request.url?.absoluteString.contains("https://rafaelescaleira.github.io/GitHub/?code=") == false { return }
        
        GitHubAPIV4.requestForCallbackURL(urlString: navigationAction.request.url?.absoluteString ?? "") { (isSuccess) in
            
            DispatchQueue.main.async {
                
                if isSuccess { self.performSegue(withIdentifier: "Home", sender: nil) }
                else {  }
            }
        }
    }
}

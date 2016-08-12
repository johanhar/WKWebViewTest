//
//  ViewController.swift
//  WKWebViewTest
//
//  Created by Johannes H on 11.08.2016.
//  Copyright © 2016 Johannes Harestad. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {

    var webView: WKWebView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        
        contentController.addScriptMessageHandler(self, name: "callbackHandler")
        
        let wkConfig = WKWebViewConfiguration()
        wkConfig.userContentController = contentController
        
        webView = WKWebView(frame: view.bounds, configuration: wkConfig)
        view.addSubview(webView)
       
        /* 
         if you want to use local files, this is how you do can do it
        
        if let webAppPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString(webDir) {
            let webAppURL = NSURL(fileURLWithPath: webAppPath, isDirectory: true)
            
            // Locate the index.html file
            if let indexPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("\(webDir)/index.html") {
                let indexURL = NSURL(fileURLWithPath: indexPath)
                
                webView.loadFileURL(indexURL, allowingReadAccessToURL: webAppURL)
            }
        }*/
        
        
        /*
         USE A SERVER/LOCALHOST
         `npm start` inside AngularApp
         */
        let localhostURL = NSURL(string: "http://localhost:8000")!
        let localhostRequest = NSURLRequest(URL: localhostURL)
        webView.loadRequest(localhostRequest)
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            
            guard let data = message.body as? [String: AnyObject] else {
                return
            }
                
            guard let somethingUnique = data["unique"] else {
                return
            }
            
            guard let message = data["message"] else {
                return
            }
            
            let randomTime = Double(arc4random_uniform(2) + 3) // between 2 and 5 seconds waiting time
            
            print("Received data from JavaScript, doing some async work that will take \(randomTime) seconds")
            
            let dispatchDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(randomTime * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchDelay, dispatch_get_main_queue()) { [unowned self] in
                print("Will return to JavaScript with some data")
                let evaluate = "callMeFromSwift({'unique': \(somethingUnique), 'message': '\(message)'})"
                self.webView.evaluateJavaScript(evaluate, completionHandler: nil)
            }
            
        }
    }
}
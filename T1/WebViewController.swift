//
//  WebViewController.swift
//  sheng_si_hen
//
//  Created by Rong GONG on 02/06/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var url_string: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: url_string)
        let request = URLRequest(url:url!)
        webView.load(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  NetworkManager.swift
//  sheng_si_hen
//
//  Created by Rong GONG on 28/05/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import Foundation
import Alamofire

class BackendAPIManager: NSObject {
    static let sharedInstance = BackendAPIManager()
    
    var alamoFireManager : Alamofire.SessionManager!
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return alamoFireManager?.backgroundCompletionHandler
        }
        set {
            alamoFireManager?.backgroundCompletionHandler = newValue
        }
    }
    
    fileprivate override init()
    {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.url.background")
        configuration.timeoutIntervalForRequest = 200 // seconds
        configuration.timeoutIntervalForResource = 200
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
}


//
//  RJPlayerContorllerView.swift
//  T1
//
//  Created by Me on 2016-04-03.
//  Copyright © 2016 Me. All rights reserved.
//

import Foundation
import UIKit

class RJPlayerContorllerView: UIView {
    @IBAction func clickLaoshiBtn(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":1])
        print("Laoshi btn.")
    }
    
    @IBAction func clickXueshengBtn(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":2])
        print("Xuesheng btn.")

    }
    @IBAction func clickPuziBtn(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name("switchVideo"),
                                        object: nil,
                                        userInfo: ["idx":3])
        print("puzi btn.")

    }
    }

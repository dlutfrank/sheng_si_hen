//
//  AVPlayerViewController_touch.swift
//  T1
//
//  Created by Rong GONG on 14/04/2018.
//  Copyright © 2018 MTG NACTA. All rights reserved.
//

import Foundation
import AVKit

extension Notification.Name {
    static let kAVPlayerViewControllerDismissingNotification = Notification.Name.init("dismissing")
}

class AVPlayerViewController_touch: AVPlayerViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        NotificationCenter.default.post(name:Notification.Name("wakeOverlayView"),
                                        object: nil,
                                        userInfo: nil)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }
        // and then , post a simple notification and observe & handle it, where & when you need to.....
        NotificationCenter.default.post(name: .kAVPlayerViewControllerDismissingNotification, object: nil)
    }
}

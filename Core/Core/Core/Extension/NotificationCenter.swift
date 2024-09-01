//
//  NotificationCenter.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
/**
 Available Notification that will posted from this source code file.
 */
public extension Notification.Name {
    // MARK: - Shorthand
    /**
     Shorthand for posting Notification
     */
    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    static let LanguageDidChange = Notification.Name(rawValue: "languageDidChange")
    static let UserDidChange = Notification.Name(rawValue: "UserDidChange")
    static let UserDetailSuccess = Notification.Name(rawValue: "UserDetailSuccess")
}

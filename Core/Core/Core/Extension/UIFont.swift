//
//  UIFont.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/5/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import UIKit

public enum SupportedFont:String {
    
    case medium = "SukhumvitSet-Medium"
    case text = "SukhumvitSet-Text"
    case thin = "SukhumvitSet-Thin"
    case semiBold = "SukhumvitSet-SemiBold"
    case light = "SukhumvitSet-Light"
    case bold = "SukhumvitSet-Bold"
    
    func of(size:CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

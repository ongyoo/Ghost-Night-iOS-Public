//
//  UIDevice+Extension.swift
//  Core
//
//  Created by Komsit Developer on 2020-06-02.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var rawModelType: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    var bottomPadding: CGFloat {
        if #available(iOS 11.0, *) {
            guard let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else { return 0 }
            return bottomPadding
        } else {
            return 0
        }
    }
}


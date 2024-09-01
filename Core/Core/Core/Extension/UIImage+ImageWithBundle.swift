//
//  UIImage+ImageWithBundle.swift
//  Core
//
//  Created by Komsit Developer on 2020-05-29.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit

public extension UIImage {
    //Example:: imageView.image = UImage.imageNamed("xxxx", self)
    class func imageNamed(_ name: String,_ anObject: Any) -> UIImage? {
        let image = UIImage(named: name, in: Bundle(for: type(of: anObject) as! AnyClass), compatibleWith: nil)
        return image ?? nil
    }
    //Example:: imageView.image = UImage.imageNamedWithBundle("xxxx", "com.tdcm.legacy")
    //If you need images from other modules. You should call this method and define the bundleIdentifier.
    class func imageNamedWithBundle(_ name: String,_ bundleIdentifier: String = "com.komsit.ghostnight") -> UIImage? {
        let image = UIImage(named: name, in: Bundle(identifier: bundleIdentifier), compatibleWith: nil)
        return image ?? nil
    }
    
    class func imageNamedWithBundle(_ name: String,_ bundle: Bundle) -> UIImage? {
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        return image ?? nil
    }
    
}

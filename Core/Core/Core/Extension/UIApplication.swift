//
//  UIApplication.swift
//  Core
//
//  Created by Komsit Chusangthong on 5/4/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit

// MARK :- TopViewController
public extension UIApplication {
    class func getTopViewController(baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigation = baseViewController as? UINavigationController {
            return getTopViewController(baseViewController: navigation.visibleViewController)
        } else if let tabBar = baseViewController as? UITabBarController, let selected = tabBar.selectedViewController {
            return getTopViewController(baseViewController: selected)
        } else if let presented = baseViewController?.presentedViewController {
            return getTopViewController(baseViewController: presented)
        }
        return baseViewController
    }
}

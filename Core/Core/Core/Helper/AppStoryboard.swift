//
//  AppStoryboard.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/6/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//
import UIKit
import Foundation

public enum AppStoryboard: String {
    case Main
    case Component
    case Login
    case Register
    case AlertCustom
    case Profile
    case ArticleDetail
    case AudioPlayer
    case PlayList
    
    public var bundleId: Bundle {
        switch self {
        case .AudioPlayer, .PlayList:
            return ConfigBundle.ghostNightPlayer
        case .Component, .AlertCustom:
            return ConfigBundle.component
        case .Main:
            // Main
            return ConfigBundle.ghostNightMain
        default:
            // Main
            return ConfigBundle.ghostNightMain
        }
    }
  
    public var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: bundleId)
    }
    
    public func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardId
        guard let vc = instance.instantiateViewController(withIdentifier: storyboardId) as? T else { return nil }
        return vc
    }
    
    public func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}

public extension UIViewController {
    class var storyboardId: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self? {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}


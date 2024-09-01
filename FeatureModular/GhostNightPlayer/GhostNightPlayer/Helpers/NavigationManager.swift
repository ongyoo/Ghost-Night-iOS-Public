//
//  NavigationManager.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-06-07.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController
import Foundation
import Data

enum NavigationOpeningSender {
    case playList(UIViewController)
}

final class NavigationManager {
    static func pushViewController(to: NavigationOpeningSender) {
    }
    
    static func presentViewController(to: NavigationOpeningSender) {
        switch to {
        case let .playList(target):
            if let target = target as? BaseViewController,
                let modal = PlayListViewController.instantiateFromAppStoryboard(appStoryboard: .PlayList) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                target.present(modal, animated: true, completion: nil)
            }
        default: break
            
        }
    }
}

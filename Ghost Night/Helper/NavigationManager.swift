//
//  NavigationManager.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/6/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController
import Foundation
import Data
import GhostNightPlayer

enum NavigationOpeningSender {
    case login(UIViewController)
    case register(UIViewController, FacebookResponse?)
    case profile(UIViewController)
    case articleDetail(ContentItem, UIViewController?)
    case audioPlayer(ContentItem, UIViewController)
    case playList(UIViewController)
}

final class NavigationManager {

    class func pushViewController(to: NavigationOpeningSender) {
        switch to {
        case let .articleDetail(content, target):
            if let target = target ?? UIApplication.getTopViewController() {
                if let vc = ArticleDetailViewController.instantiateFromAppStoryboard(appStoryboard: .ArticleDetail) {
                    vc.config(viewModel: ArticleDetailViewModel(content: content))
                    target.navigationController?.setNavigationBarHidden(false, animated: true)
                    target.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }
    
    func presentViewController2(to: NavigationOpeningSender) {
        switch to {
        case let .login(target):
            // For ios 13
            if let target = target as? BaseViewController,
               let modal = LoginViewController.instantiateFromAppStoryboard(appStoryboard: .Login) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                modal.config(viewModel: LoginViewModel())
                target.present(modal, animated: true, completion: nil)
            }
        default: break
        }
    }
    
    class func presentViewController(to: NavigationOpeningSender) {
        switch to {
        case let .login(target):
            // For ios 13
            if let target = target as? BaseViewController,
               let modal = LoginViewController.instantiateFromAppStoryboard(appStoryboard: .Login) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                modal.config(viewModel: LoginViewModel())
                target.present(modal, animated: true, completion: nil)
            }
        case let .register(target, facebook):
            if let target = target as? BaseViewController,
                let modal = RegisterViewController.instantiateFromAppStoryboard(appStoryboard: .Register) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                
                let viewModel = RegisterViewModel()
                if let facebook = facebook {
                    viewModel.syncFacebook(facebook: facebook)
                }
                
                modal.config(viewModel: viewModel)
                target.present(modal, animated: true, completion: nil)
            }
            
        case let .profile(target):
            if let target = target as? MainPlayListViewController,
                let modal = ProfileViewController.instantiateFromAppStoryboard(appStoryboard: .Profile) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                
                modal.config(viewModel: ProfileViewModelViewModel())
                target.present(modal, animated: true, completion: nil)
            }
        case let .audioPlayer(content, target):
            if let target = target as? BaseViewController,
                let modal = AudioPlayerViewController.instantiateFromAppStoryboard(appStoryboard: .AudioPlayer) {
                target.transitionDelegate.storkDelegate = target
                target.transitionDelegate.confirmDelegate = modal
                modal.transitioningDelegate = target.transitionDelegate
                modal.modalPresentationStyle = .custom
                modal.config(viewModel: AudioViewModelViewModel(content: content))
                target.present(modal, animated: true, completion: nil)
            }
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



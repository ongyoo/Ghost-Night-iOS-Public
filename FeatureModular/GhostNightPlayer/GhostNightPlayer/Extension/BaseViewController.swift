//
//  BaseViewController.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-05-25.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController

public class BaseViewController: UIViewController {
    public let transitionDelegate = SPStorkTransitioningDelegate()
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        transitionDelegate.storkDelegate = self
        self.setupNavigationItem()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.setupNavigationItem()
    }
    
    func dismissAction(completion: (()->())?) {
        SPStorkController.dismissWithConfirmation(controller: self, completion: completion)
    }
    
    private func setupNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension BaseViewController: SPStorkControllerDelegate {
    
    public func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }
    
    public func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
}

//
//  BaseViewController.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2020-05-25.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController

class BaseViewController: UIViewController {
    let transitionDelegate = SPStorkTransitioningDelegate()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        debugPrint("BaseViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionDelegate.storkDelegate = self
        self.setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }
    
    func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
}

//
//  MainAboutViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Component
import Core

final class MainAboutViewController: BaseViewController {
    @IBOutlet fileprivate weak var headerView: MainHeaderView!
    // MARK :- Life Cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setText()
    }
    
    // MARK :- SetUp
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .LanguageDidChange, object: nil)
    }
    
    private func setUp() {
        headerView.delegate = self
        headerView.setAvatarHiden()
        setText()
    }
    
    @objc private func setText() {
        headerView.reload()
        headerView.setTitle(string: "TitleMainAbout".localized)
    }
}

extension MainAboutViewController: MainHeaderDelegate {
    func didTapAvatar() {
        
    }
}

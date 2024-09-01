//
//  MainTabBarController.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2020-05-31.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import GhostNightPlayer
import Data
import Core

final class MainTabBarController: CustomTabBarController {
    private let miniPlayer = MiniAudioPlayerView.loadNib()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK :- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniPlayer()
        registerNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupMiniPlayer() {
        miniPlayer.setup(viewTarget: self)
        miniPlayer.delegate = self
    }
    
    private func registerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerManagerDidChange),
                                               name: .AudioPlayerManagerDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerManagerDidShowMiniPlayere),
                                               name: .AudioPlayerManagerDidShowMiniPlayer,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerManagerDidHidenMiniPlayer),
                                               name: .AudioPlayerManagerDidHidenMiniPlayer,
                                               object: nil)
    }
    
    @objc private func audioPlayerManagerDidChange() {
        if let item = AudioPlayerManager.shared.getContent() {
            miniPlayer.setContent(content: item)
        }
    }
    
    @objc private func audioPlayerManagerDidShowMiniPlayere() {
        miniPlayer.show()
    }
    
    @objc private func audioPlayerManagerDidHidenMiniPlayer() {
        miniPlayer.hidden()
    }
}

// MARK :- MiniAudioPlayerDelegate
extension MainTabBarController: MiniAudioPlayerDelegate {
    func tapDetailPlayerAction(content: ContentItem) {
        if let topView = UIApplication.getTopViewController() {
            NavigationManager.presentViewController(to: .audioPlayer(content, topView))
        }
    }
}

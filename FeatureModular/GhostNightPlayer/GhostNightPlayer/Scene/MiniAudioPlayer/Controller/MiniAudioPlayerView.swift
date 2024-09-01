//
//  MiniAudioPlayerView.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-05-31.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import MarqueeLabel
import Data
import Core

public protocol MiniAudioPlayerDelegate: class {
    func tapDetailPlayerAction(content: ContentItem)
}

public final class MiniAudioPlayerView: UIView {
    @IBOutlet private weak var lineTopView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: MarqueeLabel!
    @IBOutlet private weak var playlistButton: UIButton!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    
    // Delegate
    public weak var delegate: MiniAudioPlayerDelegate?
    // private
    private weak var viewTarget: UIViewController!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Initializer

    // MARK: - View Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        registerNotificationCenter()
    }
    
    //MARK :- Public
    public func setup(viewTarget: UIViewController) {
        self.viewTarget = viewTarget
        //viewTarget.view.addSubview(self)
        viewTarget.view.insertSubview(self, at: 1)
        self.snp.makeConstraints { (make) -> Void in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(100.0)
            make.height.equalTo(90.0)
        }
    }
    
    public func setContent(content: ContentItem?) {
        if let thumbnailURL = content?.thumbnailURL {
            thumbnailImageView.sd_setImage(with: thumbnailURL, placeholderImage: UIImage.imageNamedWithBundle("ic_logo", AppStoryboard.AudioPlayer.bundleId))
        }
        
        if let titleName = content?.title {
            titleLabel.text = "\(titleName) \(content?.userName ?? "-")"
        }
        
        // playing
        validatePlayButton()
        
    }
    
    public func show() {
        if !AudioPlayerManager.shared.isPlaying {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { [unowned self] in
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(UIDevice.current.hasTopNotch ? -80.0 : -48.0)
            }
            self.viewTarget.view.layoutIfNeeded()
        })
    }
    
    public func hidden() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { [unowned self] in
            self.snp.updateConstraints { (make) in
                make.bottom.equalTo(100.0)
            }
            self.viewTarget.view.layoutIfNeeded()
        })
    }
    
    public static func loadNib() -> MiniAudioPlayerView {
        guard let view = AppStoryboard.AudioPlayer.bundleId.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? Self else {
            fatalError("The nib expected its root view to be of type \(self)")
        }
        return view
    }
    
    // MARK :- Private
    private func setView() {
        // Set View
        self.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        lineTopView.cornerRadius(cornerRadius: 5.0)
    }
    
    private func registerNotificationCenter() {
        
    }
    
    private func validatePlayButton() {
        let icon = AudioPlayerManager.shared.isPlaying ? "ic_pause_mini_player" : "ic_play_mini_player"
        playButton.setImage(UIImage.imageNamedWithBundle(icon, AppStoryboard.AudioPlayer.bundleId), for: .normal)
    }
    
    // MARK :- Action
    @IBAction private func playListAction(_ sender: UIButton) {
        
    }
    
    @IBAction private func previousAction(_ sender: UIButton) {
        
    }
    
    @IBAction private func playAction(_ sender: UIButton) {
        if AudioPlayerManager.shared.isPlaying {
            AudioPlayerManager.shared.pause()
        } else {
            AudioPlayerManager.shared.play()
        }
        validatePlayButton()
    }
    
    @IBAction private func forwardAction(_ sender: UIButton) {
        
    }
    
    @IBAction private func settingAction(_ sender: UIButton) {
        
    }
    
    @IBAction func tapDetailPlayerAction(_ sender: UIButton) {
        if let content = AudioPlayerManager.shared.getContent() {
            delegate?.tapDetailPlayerAction(content: content)
        }
    }
}

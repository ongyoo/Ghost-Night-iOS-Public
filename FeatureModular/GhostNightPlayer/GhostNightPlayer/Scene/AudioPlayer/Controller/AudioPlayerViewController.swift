//
//  AudioPlayerViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController
import Core
import Component
import Data

public final class AudioPlayerViewController: BaseViewController {
    @IBOutlet fileprivate weak var bgView: UIView!
    // Header
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var addPlayListButton: UIButton!
    @IBOutlet fileprivate weak var closeButton: UIButton!
    
    // Body
    @IBOutlet fileprivate weak var thumbnailView: UIView!
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var contentTitleLabel: UILabel!
    @IBOutlet fileprivate weak var contentUserNameLabel: UILabel!
    
    // Player Control
    @IBOutlet fileprivate weak var currentTimeLabel: UILabel!
    // LiveView
    @IBOutlet fileprivate weak var liveView: UIView!
    @IBOutlet fileprivate weak var endTimeLabel: UILabel!
    @IBOutlet fileprivate weak var progressSlider: CustomSlider!
    @IBOutlet fileprivate weak var playListButton: UIButton!
    @IBOutlet fileprivate weak var settingButton: UIButton!
    @IBOutlet fileprivate weak var repeatButton: UIButton!
    @IBOutlet fileprivate weak var previousButton: UIButton!
    @IBOutlet fileprivate weak var playButton: UIButton!
    @IBOutlet fileprivate weak var nextButton: UIButton!
    @IBOutlet fileprivate weak var shfferButton: UIButton!
    
    // Footer
    @IBOutlet fileprivate weak var footerAdView: UIView!
    @IBOutlet fileprivate weak var footerAddHeight: NSLayoutConstraint!
    
    //ViewModel
    fileprivate var viewModel: AudioViewModelProtocol!
    
    // MARK:- Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        Notification.Name.AudioPlayerManagerDidHidenMiniPlayer.post()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
        viewModel.input.updateViews()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Notification.Name.AudioPlayerManagerDidShowMiniPlayer.post()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpView()
    }
    
    // MARK:- Config
    public func config(viewModel: AudioViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK:- SetUp
    private func setUp() {
        AudioPlayerManager.shared.delegate = self
        let item = viewModel.output.getContent()
        if let image = item.thumbnailURL {
            thumbnailImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "ic_logo"))
        }
        contentTitleLabel.text = item.title ?? "UserProfileNotFound".localized
        contentUserNameLabel.text = String(format: "UserProfileUserName %@".localized,
                                           item.userName ?? "UserProfileNotFound".localized)
    }
    
    private func setUpView() {
        let item = viewModel.output.getContent()
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        bgView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        
        //Set Progress Slider
        progressSlider.setMinimumTrackImage(UIImage(named: "bg_player_slider_active"), for: .normal)
        //progressSlider.setMaximumTrackImage(UIImage(named: "slider"), for: .normal)
        progressSlider.setThumbImage(UIImage(named: "ic_player_knob"), for: .normal)
        
        thumbnailView.dropShadow(color: UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0),
                                        opacity: 0.4, offSet: CGSize(width: 0, height: 4),
                                        radius: 20.0,
                                        scale: true)
        thumbnailView.cornerRadius(cornerRadius: 20.0)
        
        // Set Player
        if let image = item.thumbnailURL {
            thumbnailImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "ic_logo"))
        }
        
        contentTitleLabel.text = item.title ?? "UserProfileNotFound".localized
        contentUserNameLabel.text = String(format: "UserProfileUserName %@".localized,
                                           item.userName ?? "UserProfileNotFound".localized)
        
        // Vaidate View
        validateView()
        
        // chack current playing
        if !AudioPlayerManager.shared.isValidateCurrentContent(content: item) {
            if item.contentType == .live {
                setLiveView()
            } else {
                setEndTimeLabel()
            }
        }
        setPlayButton()
        footerAddHeight.constant = 0.0
    }
    
    private func validateView() {
        let item = viewModel.output.getContent()
        if item.contentType == .live {
            setLiveView()
        } else {
            setEndTimeLabel()
        }
    }
    
    private func liveView(isShow: Bool) {
        liveView.alpha = 0
        liveView.isHidden = !isShow
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.liveView.alpha = 1
            self.liveView.cornerRadius(cornerRadius: 2.0)
        }
    }
    
    private func setLiveView() {
        liveView(isShow: true)
        endTimeLabel.text = "Live"
        endTimeLabel.textColor = UIColor.white
        progressSlider.maximumValue = 1.0
        progressSlider.value = 1.0
        progressSlider.isEnabled = false
        
        repeatButton.isHidden = true
        previousButton.isHidden = true
        nextButton.isHidden = true
        shfferButton.isHidden = true
    }
    
    private func setEndTimeLabel() {
        let time = AudioPlayerManager.shared.getEndTime()
        endTimeLabel.text = "".timePlayer(hours: time.hours, minutes: time.minutes, seconds: time.seconds, original: 0.0)
        var maximumValue = Float(AudioPlayerManager.shared.player.currentItem?.asset.duration.seconds ?? 0.0)
        if maximumValue.isNaN {
            maximumValue = 1.0
        }
        liveView(isShow: false)
        progressSlider.maximumValue = maximumValue
    }
    
    private func setupPlayer(item: ContentItem) {
        if let _ = item.contentItemAudioURL?.absoluteString {
            AudioPlayerManager.shared.setup(content: item) { [weak self] (error) in
                guard let weakSelf = self else { return }
                if error == nil {
                    //success
                    if item.contentType == .live {
                        weakSelf.setLiveView()
                        return
                    }
                    
                    weakSelf.setEndTimeLabel()
                    return
                }
                //error
                AlertHelper.alert(title: "ErrorTitle".localized,
                                  message: "ErrorPlayerURLNotFound".localized,
                                  majorTitleButton: "AlertOK".localized,
                                  majorButtonType: .danger,
                                  majorAction: nil)
            }
            
        } else {
            AlertHelper.alert(title: "ErrorTitle".localized,
                              message: "ErrorPlayerURLNotFound".localized,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger,
                              majorAction: nil)
        }
    }
    
    private func setPlayButton() {
        if !AudioPlayerManager.shared.isValidateCurrentContent(content: viewModel.output.getContent()) {
            playButton.isSelected = AudioPlayerManager.shared.isPlaying
            return
        }
        playButton.isSelected = false
    }
    
    private func comingsoon() {
        AlertHelper.alert(title: "ErrorTitle".localized,
                          message: "รอก่อนะจ๊ะ",
                          majorTitleButton: "AlertOK".localized,
                          majorButtonType: .danger,
                          majorAction: nil)
    }
    
    // MARK :- Action
    @IBAction private func addPlayListAction(_ sender: UIButton) {
        AudioPlayerManager.shared.play()
    }
    
    @IBAction private func closeAction(_ sender: UIButton) {
        dismissAction(completion: nil)
    }
    
    @IBAction private func playListAction(_ sender: UIButton) {
        NavigationManager.presentViewController(to: .playList(self))
    }
    
    @IBAction private func settingAction(_ sender: UIButton) {
        comingsoon()
    }
    
    @IBAction private func repeatAction(_ sender: UIButton) {
        comingsoon()
    }
    
    @IBAction private func previousAction(_ sender: UIButton) {
        comingsoon()
    }
    
    @IBAction private func playAction(_ sender: UIButton) {
        let isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
        if !isSelected {
            let item = viewModel.output.getContent()
            setupPlayer(item: item)
            AudioPlayerManager.shared.play()
        } else {
            AudioPlayerManager.shared.pause()
        }
    }
    
    @IBAction private func nextAction(_ sender: UIButton) {
        comingsoon()
    }
    
    @IBAction private func shfferAction(_ sender: UIButton) {
        comingsoon()
    }
    
    @IBAction func progressSliderAction(_ sender: CustomSlider) {
        AudioPlayerManager.shared.seekTime(value: Double(sender.value))
    }
}

extension AudioPlayerViewController: StreamPlayerDelegate {
    public func updatePlayerCurrentTime(hours: Int, minutes: Int, seconds: Int, original: Double) {
        if !AudioPlayerManager.shared.isValidateCurrentContent(content: viewModel.output.getContent()) {
            if viewModel.output.getContent().contentType == .live {
                currentTimeLabel.text = "-:-"
                return
            }
            currentTimeLabel.text = "".timePlayer(hours: hours, minutes: minutes, seconds: seconds, original: original)
            progressSlider.value = Float(original)
        }
    }
    
    public func streamPlayerFailedToPlayToEndTime() {
        AlertHelper.alert(title: "ErrorTitle".localized,
                          message: "ErrorPlayerURLNotFound".localized,
                          majorTitleButton: "AlertOK".localized,
                          majorButtonType: .danger,
                          majorAction: nil)
    }
    
    public func streamPlayerPlaybackStalled() {
        AlertHelper.alert(title: "ErrorTitle".localized,
                          message: "ErrorPlayerURLNotFound".localized,
                          majorTitleButton: "AlertOK".localized,
                          majorButtonType: .danger,
                          majorAction: nil)
    }
    
    public func itemDidPlayToEndTime() {
        AudioPlayerManager.shared.stop()
        setPlayButton()
    }
}

extension AudioPlayerViewController: SPStorkControllerConfirmDelegate {
    public var needConfirm: Bool {
        return false
    }
    
    public func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}

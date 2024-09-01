//
//  AudioPlayerManager.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/5/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//
import Foundation
import AVKit
import AVFoundation
import RxSwift
import Data

public protocol StreamPlayerDelegate {
    func streamPlayerFailedToPlayToEndTime()
    func streamPlayerPlaybackStalled()
    func updatePlayerCurrentTime(hours: Int, minutes: Int, seconds: Int, original: Double)
    func itemDidPlayToEndTime()
}

final public class AudioPlayerManager: NSObject {
    public static let shared = AudioPlayerManager()
    let player = AVPlayer()
    var item: AVPlayerItem? {
        willSet {
            guard item != nil else { return }
            removeObserver()
        }
    }
    
    var isPlaying: Bool {
        return player.rate == 1 && player.error == nil
    }
    
    var url: URL?
    
    var timeObserverToken: Any?
    
    var delegate: StreamPlayerDelegate?
    
    lazy var viewModel: AudioPlayerManagerProtocol = {
        return AudioPlayerManagerViewModel()
    }()
    
    deinit {
        removeObserver()
    }
    
    override public init() {
        super.init()
        registerObserve()
    }
    
    func setup(content: ContentItem, completion: @escaping URLSetupCompletion) {
        func complete(_ error: AudioPlayerManagerViewModel.StreamError?) { completion(error) }
        viewModel.input.setContent(content: content)
        if let urlString = viewModel.output.getContentURLData()?.absoluteString {
            let urlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard urlString != url?.absoluteString, !viewModel.output.isCurrent() else { return complete(nil) }
            guard let url = URL(string: urlString) else { return complete(.unvalidURL) }
            let asset = AVAsset(url: url)
            guard asset.isPlayable else { return complete(.unvalidURL) }
            asset.cancelLoading()
            item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
        }
        
        complete(nil)
    }
    
    private func registerObserve() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemNewErrorLogEntry(_:)),
                                               name: .AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemPlaybackStalled(_:)),
                                               name: .AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(itemPlaybackStalled(_:)),
                                               name: .AVAssetDurationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
    }
    
    func play() {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        player.volume = 1
        player.play()
        addPeriodicTimeObserver()
        Notification.Name.AudioPlayerManagerDidChange.post()
    }
    
    func pause() {
        player.pause()
        try? AVAudioSession.sharedInstance().setActive(false)
        UIApplication.shared.endReceivingRemoteControlEvents()
        removePeriodicTimeObserver()
        Notification.Name.AudioPlayerManagerDidChange.post()
    }
    
    func stop() {
        player.pause()
        item = nil
        player.replaceCurrentItem(with: item)
        Notification.Name.AudioPlayerManagerDidChange.post()
    }
    
    func seekTime(value: Double) {
        let playerTimescale = self.player.currentItem?.asset.duration.timescale ?? 1
        let time =  CMTime(seconds: value, preferredTimescale: playerTimescale)
        self.player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (finished) in
            /* Add your completion code here */
            debugPrint("seekTime : \(finished)")
        }
    }
    
    // MARK : - Validate
    func isValidateCurrentContent(content: ContentItem) -> Bool {
        return viewModel.output.isValidateCurrentContent(content: content)
    }
}

public extension AudioPlayerManager {
    func getEndTime() -> (hours: Int, minutes: Int, seconds: Int) {
        return timeDivider(seconds: player.currentItem?.asset.duration.seconds ?? 0.0)
    }
    
    func getCurrentTime() -> (hours: Int, minutes: Int, seconds: Int) {
        return timeDivider(seconds: player.currentItem?.currentTime().seconds ?? 0.0)
    }
    
    func timeDivider(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return (0,0,0)
        }
        let secs: Int = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func getContent() -> ContentItem? {
        return viewModel.output.getContentData()
    }
}

internal extension AudioPlayerManager {
    @objc func itemFailedToPlayToEndTime(_ notification: Notification) {
        let error = notification.userInfo?.first(where: { $0.value is Error }) as? Error
        debugPrint(error?.localizedDescription ?? "No error description for itemFailedToPlayToEndTime")
        delegate?.streamPlayerFailedToPlayToEndTime()
    }
    
    @objc func itemPlaybackStalled(_ notification: Notification) {
        let error = notification.userInfo?.first(where: { $0.value is Error }) as? Error
        debugPrint(error?.localizedDescription ?? "No error description for itemPlaybackStalled")
        delegate?.streamPlayerPlaybackStalled()
    }
    
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        let error = notification.userInfo?.first(where: { $0.value is Error }) as? Error
        debugPrint(error?.localizedDescription ?? "No error description for itemNewErrorLogEntry")
        delegate?.streamPlayerPlaybackStalled()
    }
    
    @objc func itemDidPlayToEndTime(_ notification: Notification) {
        debugPrint("itemDidPlayToEndTime")
        delegate?.itemDidPlayToEndTime()
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            // update player transport UI
                                                            let item = self?.timeDivider(seconds: time.seconds)
                                                            self?.delegate?.updatePlayerCurrentTime(hours: item?.hours ?? 0,
                                                                                                    minutes: item?.minutes ?? 0,
                                                                                                    seconds: item?.seconds ?? 0,
                                                                                                    original: time.seconds)
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}

public extension Notification.Name {
    static let AudioPlayerManagerDidChange = Notification.Name(rawValue: "AudioPlayerManagerDidChange")
    static let AudioPlayerManagerDidShowMiniPlayer = Notification.Name(rawValue: "AudioPlayerManagerDidShowMiniPlayer")
    static let AudioPlayerManagerDidHidenMiniPlayer = Notification.Name(rawValue: "AudioPlayerManagerDidHidenMiniPlayer")
}

//
//  AudioPlayerManagerViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/7/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

typealias URLSetupCompletion = ((AudioPlayerManagerViewModel.StreamError?) -> Void)

protocol AudioPlayerManagerProtocolInput {
    func setContent(content: ContentItem)
    func resetContent()
}

protocol AudioPlayerManagerProtocolOutput: class {
    
    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didError: ((Error) -> Void)? { get set }
    
    // Function
    func getContentData() -> ContentItem?
    func getContentURLData() -> URL?
    func isCurrent() -> Bool
    func isValidateCurrentContent(content: ContentItem) -> Bool
    
}

protocol AudioPlayerManagerProtocol: AudioPlayerManagerProtocolInput, AudioPlayerManagerProtocolOutput {
    var input: AudioPlayerManagerProtocolInput { get }
    var output: AudioPlayerManagerProtocolOutput { get }
}

final class AudioPlayerManagerViewModel: AudioPlayerManagerProtocol, AudioPlayerManagerProtocolOutput {
    
    var input: AudioPlayerManagerProtocolInput { return self }
    var output: AudioPlayerManagerProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didError: ((Error) -> Void)?
    
    // Enum
    enum StreamError: Error {
        case unknown
        case unvalidURL
        case networkError
    }
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    fileprivate var currentContent: ContentItem?
    fileprivate var isContentCrrent: Bool = false
    
    init() {
    }
    
    // Function
    func getContentData() -> ContentItem? {
        return currentContent ?? nil
    }
    
    func getContentURLData() -> URL? {
        return currentContent?.contentItemAudioURL ?? nil
    }
    
    func isCurrent() -> Bool {
        return isContentCrrent
    }
    
    func isValidateCurrentContent(content: ContentItem) -> Bool {
        return content.cmsId != currentContent?.cmsId
    }
}

extension AudioPlayerManagerViewModel: AudioPlayerManagerProtocolInput {
    func setContent(content: ContentItem) {
        if currentContent?.cmsId != content.cmsId {
            isContentCrrent = false
            currentContent = content
            return
        }
        isContentCrrent = true
    }
    
    func resetContent() {
        isContentCrrent = false
        currentContent = nil
    }
}


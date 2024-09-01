//
//  AudioPlayerViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

public protocol AudioViewModelProtocolInput {
    func updateViews()
}

public protocol AudioViewModelProtocolOutput: class {
    
    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didError: ((Error) -> Void)? { get set }
    var didErrorCustom: ((String) -> Void)? { get set }
    
    func getContent() -> ContentItem
}

public protocol AudioViewModelProtocol: AudioViewModelProtocolInput, AudioViewModelProtocolOutput {
    var input: AudioViewModelProtocolInput { get }
    var output: AudioViewModelProtocolOutput { get }
}

final public class AudioViewModelViewModel: AudioViewModelProtocol, AudioViewModelProtocolOutput {
    
    public var input: AudioViewModelProtocolInput { return self }
    
    public var output: AudioViewModelProtocolOutput { return self }
    
    public var showLoading: (() -> Void)?
    
    public var hideLoading: (() -> Void)?
    
    public var didError: ((Error) -> Void)?
    
    public var didErrorCustom: ((String) -> Void)?
    
    var reloadData: (() -> Void)?
    
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    fileprivate var content: ContentItem
    
    // UseCase
    fileprivate var viewerUseCase: UpdateContetViewerUseCase?
    
    public func getContent() -> ContentItem {
        return content
    }
    
    public init(content: ContentItem, viewerUseCase: UpdateContetViewerUseCase? = UpdateContetViewerUseCaseImpl()) {
        self.content = content
        self.viewerUseCase = viewerUseCase
    }
}

// MARK : - Input
extension AudioViewModelViewModel: AudioViewModelProtocolInput {
    public func updateViews() {
    if let cmsId = self.content.cmsId {
           viewerUseCase?.execute(cmsId: cmsId).subscribe(onNext: { response in
           }, onError: { error in
           }, onDisposed: nil).disposed(by: self.disposeBag)
       }
   }
}

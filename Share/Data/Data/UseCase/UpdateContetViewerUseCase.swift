//
//  UpdateContetViewerUseCase.swift
//  Data
//
//  Created by Komsit Developer on 2020-05-25.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateContetViewerUseCase {
    func execute(cmsId: String) -> Observable<BaseResponse>
}

final public class UpdateContetViewerUseCaseImpl: NSObject, UpdateContetViewerUseCase {
    private var feedRepository: FeedRepository!
    fileprivate var disposeBag = DisposeBag()
    
    public init(repo: FeedRepository = FeedRepositoryImpl()) {
        self.feedRepository = repo
    }
    
    public func execute(cmsId: String) -> Observable<BaseResponse> {
        return feedRepository.updateContetViewer(cmsId: cmsId)
    }
}

//
//  ContentListUseCase.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2019-11-22.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

protocol ContentListUseCase {
    func execute(cmsId: String) -> Observable<ContentListReponse>
}

final class ContentListUseCaseImpl: ContentListUseCase {
    private var feedRepository: FeedRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: FeedRepository = FeedRepositoryImpl()) {
        self.feedRepository = repo
    }
    
    func execute(cmsId: String) -> Observable<ContentListReponse> {
        return feedRepository.contentListByShelfCmsId(cmsId: cmsId)
    }
}


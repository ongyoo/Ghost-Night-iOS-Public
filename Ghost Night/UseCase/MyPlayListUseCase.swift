//
//  MyPlayListUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 1/18/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

protocol MyPlayListUseCase {
    func execute(cmsId: String, token: String) -> Observable<ContentPlayListResponse>
}

final class MyPlayListUseCaseImpl: MyPlayListUseCase {
    private var feedRepository: FeedRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: FeedRepository = FeedRepositoryImpl()) {
        self.feedRepository = repo
    }
    
    func execute(cmsId: String, token: String) -> Observable<ContentPlayListResponse> {
        return feedRepository.myPlayList(cmsId: cmsId, token: token)
    }
}

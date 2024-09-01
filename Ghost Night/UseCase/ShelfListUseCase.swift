//
//  ShelfListUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

enum ShelfType: String {
    case contentPlayList = "content_play_list"
    case contentFeed = "content_feed"
}

protocol ShelfListUseCase {
    func execute(slug: ShelfType) -> Observable<ShelfListReponse>
}

final class ShelfListUseCaseImpl: ShelfListUseCase {
    private var feedRepository: FeedRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: FeedRepository = FeedRepositoryImpl()) {
        self.feedRepository = repo
    }
    
    func execute(slug: ShelfType) -> Observable<ShelfListReponse> {
        return feedRepository.shelfList(slug: slug.rawValue)
    }
}

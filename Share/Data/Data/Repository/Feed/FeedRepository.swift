//
//  FeedRepository.swift
//  Data
//
//  Created by Komsit Developer on 2020-05-25.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol FeedRepository {
    func shelfList(slug: String) -> Observable<ShelfListReponse>
    func contentListByShelfCmsId(cmsId: String) -> Observable<ContentListReponse>
    func myPlayList(cmsId: String, token: String) -> Observable<ContentPlayListResponse>
    func updateContetViewer(cmsId: String) -> Observable<BaseResponse>
}

final public class FeedRepositoryImpl: FeedRepository {
    private let feedProvider = MoyaProvider<FeedAPI>()
    
    public init() {}
    
    public func shelfList(slug: String) -> Observable<ShelfListReponse> {
        return feedProvider
            .rx
            .request(.shelfList(slug: slug))
            .mapObject(ShelfListReponse.self)
            .asObservable()
    }
    
    public func contentListByShelfCmsId(cmsId: String) -> Observable<ContentListReponse> {
        return feedProvider
            .rx
            .request(.contentListByShelfCmsId(cmsId: cmsId))
            .mapObject(ContentListReponse.self)
            .asObservable()
    }
    
    public func myPlayList(cmsId: String, token: String) -> Observable<ContentPlayListResponse> {
        return feedProvider
            .rx
            .request(.myPlayList(cmsId: cmsId, token: token))
            .mapObject(ContentPlayListResponse.self)
            .asObservable()
    }
    
    public func updateContetViewer(cmsId: String) -> Observable<BaseResponse> {
        return feedProvider
            .rx
            .request(.updateContetViewer(cmsId: cmsId))
            .mapObject(BaseResponse.self)
            .asObservable()
    }
}


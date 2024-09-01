//
//  FeedAPI.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import Moya

public enum FeedAPI {
    case shelfList(slug: String)
    case contentListByShelfCmsId(cmsId: String)
    case myPlayList(cmsId: String, token: String)
    case updateContetViewer(cmsId: String)
}

extension FeedAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .shelfList, .contentListByShelfCmsId, .myPlayList, .updateContetViewer:
            return BaseAPI.apiUrl
        }
    }
    
    public var path: String {
        switch self {
        case .shelfList:
            return "/feed/shelf_list"
        case .contentListByShelfCmsId:
            return "/feed/content_by_cmsid"
        case .myPlayList:
            return "/play_list"
        case .updateContetViewer:
            return "/content/update_viewer"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .shelfList, .contentListByShelfCmsId, .myPlayList, .updateContetViewer:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case  let .shelfList(slug):
            var request = ShelfListRequest()
            request.slug = slug
            let jsonData = try? JSONSerialization.data(withJSONObject: request.toJSON())
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: request.toJSON()))
            
        case let .contentListByShelfCmsId(cmsId):
            let data = ["cmsid" : cmsId]
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: data))
            
        case let .myPlayList(cmsId, _):
            let data = ["cmsid" : cmsId]
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: data))
            
        case let .updateContetViewer(cmsId):
            let data = ["cmsid" : cmsId]
            let jsonData = try? JSONSerialization.data(withJSONObject: data)
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: data))
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .shelfList, .contentListByShelfCmsId, .updateContetViewer:
            let header = ["Content-Type" : "application/json"]
            return header
            
            case let .myPlayList(_, token):
            let headers = ["Authorization": token, "Content-Type" : "application/json"]
            return headers
        }
    }
}

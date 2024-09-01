//
//  ContentPlayListResponse.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 1/18/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//


import ObjectMapper
import Core

final public class ContentPlayListResponse: BaseResponse {
    public var contents: [ContentPlayListItem]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    public override func mapping(map: Map) {
        super.mapping(map: map)
        contents      <- map["data.play_list_items"]
    }
}

public struct ContentPlayListItem: Mappable {
    public var cmsId: String?
    public var name: String?
    public var createDate: Date?
    public var isPublic: Bool = false
    public var contentCount: Int?
    public var thumbnailURL: URL?
    public var userName: String?

    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        cmsId                   <- map["play_list_cms_id"]
        name                    <- map["play_list_name"]
        createDate              <- (map["play_list_create_date"], DateFormatterTransform(dateFormatter: DateFormatter().isoFormatter))
        isPublic                <- map["play_list_is_public"]
        contentCount            <- map["play_list_content_count"]
        thumbnailURL            <- (map["play_list_humbnail_url"], URLTransform())
        userName                <- map["user_name"]
    }
}

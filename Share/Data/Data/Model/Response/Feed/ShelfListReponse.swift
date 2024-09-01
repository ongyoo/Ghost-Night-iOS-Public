//
//  ShelfListReponse.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

public enum ShelfSlug: String {
    case nonLogin = "shelf_nonlogin"
    case recommend = "shelf_recommend"
    case myPlayList = "shelf_my_play_list"
    case radio = "shelf_radio"
    case freedom = "shelf_non_free_dom"
    case unknown = "unknown"
}

public final class ShelfListReponse: BaseResponse {
    public var shelf: [ShelfList]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    public override func mapping(map: Map) {
        super.mapping(map: map)
        shelf      <- map["data.shelf_list"]
    }
}

public struct ShelfList: Mappable {
    public var cmsId: String?
    public var index: Int?
    public var createDate: Date?
    public var updateDate: Date?
    public var iconUrl: URL?
    public var nameEn: String?
    public var nameTh: String?
    public var slugType: ShelfSlug? = .unknown
    
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        cmsId           <- map["feed_cms_id"]
        index           <- map["feed_index"]
        createDate      <- (map["feed_create_date"], DateTransform())
        updateDate      <- (map["feed_update_date"], DateTransform())
        iconUrl         <- (map["shelf_icon_url"], URLTransform())
        nameEn          <- map["shelf_name_en"]
        nameTh          <- map["shelf_name_th"]
        slugType        <- (map["shelf_slug"], EnumTransform())
    }
}


/*
 {
 "status": 200,
 "data": {
 "shelf_list": [
 {
 "feed_cms_id": "d26ID0DyoQfDiPy",
 "feed_index": 0,
 "feed_create_date": "2019-11-19T00:00:00.000Z",
 "feed_update_date": "2019-11-19T07:36:34.000Z",
 "shelf_icon_url": null,
 "shelf_name_en": "NonLogin",
 "shelf_name_th": "ยังไม่เข้าระบบ",
 "shelf_slug": "shelf_nonlogin"
 },
 {
 "feed_cms_id": "BPrPLQ5npDZ5Il7",
 "feed_index": 1,
 "feed_create_date": "2019-11-19T00:00:00.000Z",
 "feed_update_date": "2019-11-19T07:14:49.000Z",
 "shelf_icon_url": "https://s3-ap-southeast-1.amazonaws.com/ghost.night/shelf_icon/shelf_icon_recommend.png",
 "shelf_name_en": "Recommend",
 "shelf_name_th": "รายการแนะนำ",
 "shelf_slug": "shelf_recommend"
 }
 ]
 },
 "message": "",
 "result": true
 }
 */

//
//  ContentListReponse.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2019-11-22.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//
import AVFoundation
import ObjectMapper

public enum ContentType: String {
    case content = "content"
    case audio = "audio"
    case live = "live"
    case playList = "playList"
}

final public class ContentListReponse: BaseResponse {
    public var contents: [ContentItem]?
    
    override init() {
        super.init()
    }
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    public override func mapping(map: Map) {
        super.mapping(map: map)
        contents      <- map["data.content_list"]
    }
}

public struct ContentItem: Mappable {
    public var shelfItemId: String?
    public var id: String?
    public var title: String?
    public var cmsId: String?
    public var detail: String?
    public var rate: Int?
    public var viewer: String?
    public var sort: Int?
    public var thumbnailURL: URL?
    public var county: String?
    public var contentType: ContentType?
    public var contentTypeString: String?
    public var updateDate: Date?
    public var userTier: [String]?
    public var userName: String?
    public var contentArticleHtml: String?
    public var contentArticleMedia: [URL]?
    public var contentItemAudioURL: URL?
//    var playerItem: AVPlayerItem? {
//        return AudioPlayerManager.shared.generateAVPlayerItem(url: contentItemAudioURL)
//    }
    
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        shelfItemId             <- map["shelf_item_id"]
        id                      <- map["content_item_id"]
        title                   <- map["content_item_title"]
        cmsId                   <- map["content_item_cms_id"]
        detail                  <- map["content_item_detail"]
        rate                    <- map["content_item_rate"]
        sort                    <- map["content_item_sort"]
        thumbnailURL            <- (map["content_item_thumbnail_url"], URLTransform())
        county                  <- map["content_item_county"]
        viewer                  <- map["content_item_viewer"]
        contentType             <- (map["content_item_type"], EnumTransform())
        contentTypeString       <- map["content_item_type"]
        updateDate              <- (map["content_item_update_date"], DateFormatterTransform(dateFormatter: DateFormatter().isoFormatter))
        userTier                <- map["shelf_user_tier"]
        userName                <- map["user_name"]
        contentArticleHtml      <- map["content_article_html"]
        contentArticleMedia     <- (map["content_article_media_url"], URLTransform())
        contentItemAudioURL     <- (map["content_item_audio_url"], URLTransform())
    }
}


/*
 {
     "status": 200,
     "data": {
         "content_list": [
             {
                 "shelf_item_id": "08cf1177-ca34-d2ae-dd14-88ab09385bf7",
                 "content_item_id": "1",
                 "content_item_cms_id": "KjWCXC5Bu9eepwU",
                 "content_item_detail": "ผีจีนแถวย่านประชาชื่น detail ผีจีนแถวย่านประชาชื่น detail ผีจีนแถวย่านประชาชื่น detail",
                 "content_item_detail_html": null,
                 "content_item_rate": 0,
                 "content_item_sort": "0",
                 "content_item_thumbnail_url": "https://s3.ap-southeast-1.amazonaws.com/ghost.night/content/1574146923810_download.jpeg",
                 "content_item_title": "ผีจีนแถวย่านประชาชื่น",
                 "content_item_county": "นนทบุรี",
                 "content_item_type": "content",
                 "content_item_viewer": "0",
                 "content_item_update_date": "2019-11-19T07:00:48.000Z",
                 "shelf_user_tier": []
             }
         ]
     },
     "message": "",
     "result": true
 }
*/

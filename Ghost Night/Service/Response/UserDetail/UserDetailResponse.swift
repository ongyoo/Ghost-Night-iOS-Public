//
//  UserDetailResponse.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper
import Core

final class UserDetailResponse: BaseResponse {
    var userName: String?
    var userEmail: String?
    var userIsActive: Bool?
    var userCreateDate: Date?
    var userTimestamp: Date?
    var userProfileAvatarURL: URL?
    var userFacebookId: String?
    var userIsFacebook: Bool?
    var userRoleId: String?
    var userRoleName: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        userName                <- map["data.user_name"]
        userEmail               <- map["data.user_email"]
        userIsActive            <- map["data.user_is_active"]
        userCreateDate          <- (map["data.user_create_date"], DateFormatterTransform(dateFormatter: DateFormatter().isoFormatter))
        userTimestamp           <- (map["data.user_timestamp"], DateFormatterTransform(dateFormatter: DateFormatter().isoFormatter))
        userProfileAvatarURL    <- (map["data.user_profile_avatar_url"], URLTransform())
        userFacebookId          <- map["data.user_facebook_id"]
        userIsFacebook          <- map["data.user_is_facebook"]
        userRoleId              <- map["data.user_role_id"]
        userRoleName            <- map["data.user_role_name"]
    }
    
}


/*
 {
 "status": 200,
 "data": {
 "user_name": "อ๋อง ประชานิเวศน์",
 "user_email": "ongyoo53@gmail.com",
 "user_is_active": true,
 "user_create_date": "2019-11-17T00:00:00.000Z",
 "user_timestamp": "2019-11-17T18:24:17.643Z",
 "user_profile_avatar_url": null,
 "user_facebook_id": null,
 "user_is_facebook": false,
 "user_role_id": "56711b03-2dd3-9691-a7e4-34e34fbe6484",
 "user_role_name": "Super Boss Ghost"
 },
 "message": "",
 "result": true
 }
 */

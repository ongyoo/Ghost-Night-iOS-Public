//
//  FacebookResponse.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 10/18/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

class FacebookResponse: Mappable {
    var fbId: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var name: String?
    var pictureURL: URL?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        fbId <- map["id"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        name <- map["name"]
        pictureURL <- (map["picture.data.url"], URLTransform())
    }
}


/*
 {
 email = "komsit53@gmail.com";
 "first_name" = "\U0e04\U0e21\U0e2a\U0e34\U0e17\U0e18\U0e34\U0e4c";
 id = 2123840974531856;
 "last_name" = "\U0e0a\U0e39\U0e41\U0e2a\U0e07\U0e17\U0e2d\U0e07";
 name = "\U0e04\U0e21\U0e2a\U0e34\U0e17\U0e18\U0e34\U0e4c \U0e0a\U0e39\U0e41\U0e2a\U0e07\U0e17\U0e2d\U0e07";
 picture =     {
 data =         {
 height = 200;
 "is_silhouette" = 0;
 url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2123840974531856&height=200&width=200&ext=1542401485&hash=AeTSLXopNbwNNRMH";
 width = 200;
 };
 };
 }
 ["picture": {
 data =     {
 height = 200;
 "is_silhouette" = 0;
 url = "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2123840974531856&height=200&width=200&ext=1542401485&hash=AeTSLXopNbwNNRMH";
 width = 200;
 };
 }, "name": คมสิทธิ์ ชูแสงทอง, "last_name": ชูแสงทอง, "email": komsit53@gmail.com, "id": 2123840974531856, "first_name": คมสิทธิ์]
 */

//
//  SignUpRequest.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

struct SignUpRequest: Mappable {
    var username: String?
    var userEmail: String?
    var userPassword: String?
    
    // For Facebook
    var facebookId: String?
    var profileURL: String?
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        username           <- map["user_name"]
        userEmail          <- map["user_email"]
        userPassword       <- map["user_password"]
        facebookId         <- map["facebook_id"]
        profileURL         <- map["profile_url"]
    }
}


/*
 {
 "user_name" : "อ๋อง ประชานิเวศน์",
 "user_email" : "ongyoo53@gmail.com",
 "user_password" : "060083022"
 }
 */

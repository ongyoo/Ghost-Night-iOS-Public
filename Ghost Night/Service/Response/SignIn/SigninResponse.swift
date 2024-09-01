//
//  SigninResponse.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 4/24/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

class SigninResponse: BaseResponse {
    var userId: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId      <- map["data.user_id"]
    }
    
}


/*
 {
 "status": 200,
 "data": {
 "user_id": "U2FsdGVkX1+UBynf0f9w4Sbg2i83QCd/gkwmNh7XNQNHsVnFySpq+WvcJ3Drg8wJWdRh1xJFoStH1ZeEJof3tw=="
 },
 "message": "",
 "result": true
 }
 */



//
//  SignUpResponse.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

final class SignUpResponse: BaseResponse {
    var dataMessage: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        dataMessage      <- map["data.message"]
    }
    
}

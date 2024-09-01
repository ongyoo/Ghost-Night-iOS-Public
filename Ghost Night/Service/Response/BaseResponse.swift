//
//  BaseResponse.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 4/24/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

class BaseResponse: Mappable {
    var status: Int?
    var message: String?
    var result: Bool?
    //var data: DataResponse?
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        result <- map["result"]
    }
}


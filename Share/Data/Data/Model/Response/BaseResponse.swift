//
//  BaseResponse.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 4/24/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

public class BaseResponse: Mappable {
    public var status: Int?
    public var message: String?
    public var result: Bool?
    //var data: DataResponse?
    
    init() {}
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        result <- map["result"]
    }
}


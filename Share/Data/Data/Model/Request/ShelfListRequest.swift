//
//  ShelfListRequest.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2019-11-21.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import ObjectMapper

struct ShelfListRequest: Mappable {
    var slug: String?
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        slug           <- map["slug"]
    }
}


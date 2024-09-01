//
//  ContentModel.swift
//  Ghost Night
//
//  Created by Komsit Developer on 2019-11-22.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import Data

struct ContentModel {
    var shelfItem: ShelfList?
    var contentList: [ContentItem]?
    var contentItem: ContentItem? // For FreeDom
    var myPlayList: [ContentPlayListItem]?
    var isContentListLoaded = false
    var isLoading = false
}

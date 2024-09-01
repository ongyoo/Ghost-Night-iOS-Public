//
//  RunTimeCache.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 2/18/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import Foundation


open class RunTimeCache: NSObject {
  
  let cache : NSCache<AnyObject, AnyObject>
  static let sharedInstance = RunTimeCache()
  
  //MARK:- Variable declerations
  override init() {
    cache = NSCache<AnyObject, AnyObject>()
  }
  
  func setObjectInCache(object:AnyObject, key:AnyObject) {
    cache.setObject(object, forKey: key)
  }
  
  func getObjectFromCache(key:AnyObject) -> AnyObject {
    var object : AnyObject = AnyObject.self as AnyObject
    
    if let cachedVersion = cache.object(forKey: key) {
      // use the cached version
      object = cachedVersion
    } else {

    }

    return object
  }
  
  func removeSingleObject(key:AnyObject) {
    cache.removeObject(forKey: key)
  }
  
  func destroyCache() {
    cache.removeAllObjects()
  }
}

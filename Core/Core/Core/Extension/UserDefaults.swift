//
//  UserDefaults.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/5/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation

public struct UserDefaultsKey {
    static let AppLanguage = UserDefaultsKey("AppLanguage")
    
    private let key: String
    
    static func save() {
        UserDefaults.standard.synchronize()
    }
    
    init(_ key: String) {
        self.key = key
    }
    
    var value: Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    var bool: Bool {
        return (UserDefaults.standard.object(forKey: key) as? Bool) ?? false
    }
    
    var integer: Int? {
        return UserDefaults.standard.object(forKey: key) as? Int
    }
    
    var double: Double? {
        return UserDefaults.standard.object(forKey: key) as? Double
    }
    
    var string: String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    var stringArray: [String]? {
        return UserDefaults.standard.object(forKey: key) as? [String]
    }
    
    var language: Language {
        return (UserDefaults.standard.object(forKey: key) as? Language)!
    }
    
    var date: Date? {
        return UserDefaults.standard.object(forKey: key) as? Date
    }
    
    var data: Data? {
        return UserDefaults.standard.object(forKey: key) as? Data
    }
    
    func set(value:Any?, save:Bool=true) {
        UserDefaults.standard.set(value, forKey: key)
        if save {
            setNamedTimeout("saveUserDefaults", delay: 0.2) {
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func remove(save:Bool=true) {
        UserDefaults.standard.removeObject(forKey: key)
        if save {
            setNamedTimeout("saveUserDefaults", delay: 0.2) {
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func setNamedTimeout(_ name: String, delay: TimeInterval, block: @escaping () -> Void) {
        _ = dispatch(.main) {
            TimeoutRepo.shared.timeouts[name]?.invalidate()
            TimeoutRepo.shared.timeouts[name] = Timer.scheduledTimer(timeInterval: delay, target: BlockOperation {
                TimeoutRepo.shared.timeouts.removeValue(forKey: name)
                block()
            }, selector: #selector(Operation.main), userInfo: nil, repeats: false)
        }
    }
}

fileprivate class TimeoutRepo {
    
    static let shared = TimeoutRepo()
    
    fileprivate var timeouts = [String: Timer]()
    
    private init() { }
}


public enum GCD {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    var queue: DispatchQueue {
        switch self {
        case .main:
            return DispatchQueue.main
        case .userInteractive:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        case .userInitiated:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        case .utility:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        case .background:
            return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        }
    }
}

public typealias Dispatch = DispatchWorkItem

public func dispatch(_ gcd: GCD, in seconds: Double? = nil, block: @escaping () -> Void) -> Dispatch {
    // If seconds is provided.
    if let seconds = seconds {
        let nanoSeconds = Int64(seconds * Double(NSEC_PER_SEC))
        let time = DispatchTime.now() + Double(nanoSeconds) / Double(NSEC_PER_SEC)
        return at(time, block: block, queue: gcd.queue)
    }
    // Otherwise
    return asyncNow(block, queue: gcd.queue)
}

fileprivate func asyncNow(_ block: @escaping ()->(), queue: DispatchQueue) -> Dispatch {
    let o = DispatchWorkItem(qos: queue.qos, flags: .inheritQoS, block: block)
    queue.async(execute: o)
    return o
}

fileprivate func at(_ time: DispatchTime, block: @escaping ()->(), queue: DispatchQueue) -> Dispatch {
    // See Async.async() for comments
    let r = DispatchWorkItem(qos: queue.qos, flags: .inheritQoS, block: block)
    queue.asyncAfter(deadline: time, execute: r)
    return r
}

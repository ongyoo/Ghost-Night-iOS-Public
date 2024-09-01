//
//  ObjectMapperCustomTransform.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 5/15/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import Foundation
import ObjectMapper

public let DoubleToDateTransform = TransformOf<Date, Double>(fromJSON: { (value: Double?) -> Date? in
    // transform value from Int? to NSDate?
    if var value = value {
        if value > 9999999999 {
            value = value / 1000
        }
        return Date(timeIntervalSince1970: value)
    } else {
        return nil
    }
}, toJSON: { (value: Date?) -> Double? in
    // transform value from NSDate? to Int?
    if let value = value {
        return value.timeIntervalSince1970
    }
    return nil
})

/**
 Easy converter from any JSON:(Number or String) to String.
 */
public let AnyToStringTransform = TransformOf<String, Any>(fromJSON: { (value) -> String? in
    if let value = value {
        return (value as? String) ?? String(describing: value)
    }
    return nil
}) { (str) -> Any? in
    return str
}

public let IntToStringTransform = TransformOf<String, Int>(fromJSON: { (value) -> String? in
    if let value = value {
        return String(value)
    }
    return nil
}) { (value) -> Int? in
    if let value = value {
        return Int(value)
    }
    return nil
}

public let StringToIntTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    // transform value from String? to Int?
    if let value = value {
        return Int(value)
    }
    return nil
}, toJSON: { (value: Int?) -> String? in
    // transform value from Int? to String?
    if let value = value {
        return String(value)
    }
    return nil
})

public class EscapedURLTransform : URLTransform {
    
    public override func transformFromJSON(_ value: Any?) -> URL? {
        if let urlString = value as? String,
            let escaped = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: escaped)
        }
        return nil
    }
}

public let StringToDoubleTransform = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
    // transform value from String? to Double?
    if let value = value {
        return value.doubleValue
    }
    return nil
}, toJSON: { (value: Double?) -> String? in
    // transform value from Double? to String?
    if let value = value {
        return "\(value)"
    }
    return nil
})

public let StringToBoolTransform = TransformOf<Bool, String>(fromJSON: { (value: String?) -> Bool? in
    // transform value from String? to Bool?
    return (value != nil) && (value == "1" || value!.lowercased() == "true" || value!.lowercased() == "yes")
}, toJSON: { (value: Bool?) -> String? in
    // transform value from Bool? to String?
    if let value = value {
        if (value) {
            return "1"
        }
        return "0"
    }
    return nil
})

public let IntToBoolTransform = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in
    return (value != nil) && (value == 1)
}, toJSON: { (value: Bool?) -> Int? in
    if let value = value {
        if value {
            return 1
        }
        return 0
    }
    return nil
})

public let StringToUTCDateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
    guard let value = value else { return nil }
    let formatter = DateFormatter()
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)! as Calendar
    formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.date(from: value)
}, toJSON: { (value: Date?) -> String? in
    if let value = value {
        return value.description
    }
    return nil
})

public let StringToThaiDateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
    guard let value = value else { return nil }
    let formatter = DateFormatter()
    formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)! as Calendar
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 7*60*60) as TimeZone
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.date(from: value)
}, toJSON: { (value: Date?) -> String? in
    if let value = value {
        return value.description
    }
    return nil
})

private extension String {
    var doubleValue: Double {
        if let number = NumberFormatter().number(from: self) {
            return number.doubleValue
        }
        return 0
    }
}


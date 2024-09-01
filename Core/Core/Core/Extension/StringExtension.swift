//
//  StringExtension.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/8/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation

public extension String {
    func timePlayer(hours: Int, minutes: Int, seconds: Int, original: Double) -> String {
        var startTime: String = ""
        if hours > 0 {
            if hours < 10 {
                startTime += "0\(hours):"
            } else {
                startTime += "\(hours):"
            }
        }
        
        if minutes > 0 {
            if minutes < 10 {
                startTime += "0\(minutes):"
            } else {
                startTime += "\(minutes):"
            }
        } else {
            startTime += "00:"
        }
        
        if seconds > 0 {
            if seconds < 10 {
                startTime += "0\(seconds)"
            } else {
                startTime += "\(seconds)"
            }
        } else {
            startTime += "00"
        }
        return startTime
    }
    
    func formatNumber() -> String {
        let n: Int! = Int(self) ?? 0
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {

        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n ?? 0)"

        default:
            return "\(sign)\(n ?? 0)"

        }

    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

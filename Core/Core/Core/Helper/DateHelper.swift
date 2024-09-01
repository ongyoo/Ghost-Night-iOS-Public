//
//  DateHelper.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import SwiftDate

/* Date Time Format
 
 //Day of the week
 EEEE        Thursday, วันพฤหัสบดี
 EEE, EE, E  Thu, พฤ.
 
 //Month
 MMMM        March
 MMM         Mar
 MM          03
 M           3
 
 //Day
 dd          01
 d           1
 
 //Time
 18:00
 //24 hr
 HH          18  <- 2 digits
 H           18  <- 1 digit //1-9
 //12 hr
 hh          06  <- 2 digits
 h           6   <- 1 digit
 */
public enum DateFormatPattern: String {
    case dayDateTime = "E d MMM,"
    case dayMonthYear = "d MMM yyyy"
    case fullDayDateYear = "E d MMM yyyy"
    case fullDayDateYearHeader = "EE d MMM yyyy"
    case dayDate = "E d MMM"
    case day = "d"
    case time = "HH:mm"
    case articleDetailTh = "d MMM yyyy, HH.mm"
    case articleDetailEn = "MMM d, YYYY, 'at' HH:mm"
}

public enum GMTTimezone: Int {
    case plus7 = 7
    case none = 0
}

public extension Date {
    func isBetween(_ startDate: Date, and endDate: Date) -> Bool {
        guard startDate < endDate else { return false }
        return (min(startDate, endDate) ... max(startDate, endDate)).contains(self)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var endOfDay: Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = (calendar as NSCalendar).components([.day, .month, .year], from: self)
        components.hour = 23
        components.minute = 59
        return calendar.date(from: components)!
    }
    
    func stringFormat(formatPattern:String = "yyyy'-'MM'-'dd",
                      AndTimeZoneFromGMT gmtTimezone:Int? = nil,
                      identifier: Calendar.Identifier? = .gregorian) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatPattern
        if let _identifier = identifier {
            dateFormatter.calendar = Calendar(identifier: _identifier)
        }
        if let gmtTimezone = gmtTimezone {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: gmtTimezone)
        }
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func stringDateFormat(_ formatPattern:String = "yyyy-MM-dd HH:mm:ss", timeZone:Zones? = nil,
                          identifier: Calendar.Identifier? = nil,
                          locale: Locales? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatPattern
        if let _identifier = identifier {
            dateFormatter.calendar = Calendar(identifier: _identifier)
        }
        if let _timeZone = timeZone {
            dateFormatter.timeZone = TimeZone(identifier: _timeZone.rawValue)
        }
        if let _locale = locale {
            dateFormatter.locale = Locale(identifier: _locale.rawValue)
        }
        return dateFormatter.string(from: self)
    }
    
    func stringLocaleFormat(formatPattern:String = "yyyy'-'MM'-'dd", AndTimeZoneFromGMT gmtTimezone:Int? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: Language.current == .english ? .gregorian : .buddhist)
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = formatPattern
        if let gmtTimezone = gmtTimezone {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: gmtTimezone)
        }
        return dateFormatter.string(from: self)
    }
    
    func stringLocaleFormatForce(formatPattern:String = "yyyy'-'MM'-'dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = formatPattern
        return dateFormatter.string(from: self)
    }
    
    func stringFormatThai(formatPattern:String = "yyyy'-'MM'-'dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "THA")
        dateFormatter.locale = Language.current.locale
        dateFormatter.calendar = Language.current.calendar
        dateFormatter.dateFormat = (formatPattern)
        return dateFormatter.string(from: self)
    }
    
    func stringFormatLocalThai(formatPattern:String = "yyyy'-'MM'-'dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "THA")
        dateFormatter.locale = Locale(identifier: "th_TH")
        dateFormatter.calendar = Calendar(identifier: .buddhist)
        dateFormatter.dateFormat = (formatPattern)
        return dateFormatter.string(from: self)
    }
    
    func stringFormat(formatPattern:String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = formatPattern ?? "yyyy'-'MM'-'dd"
        return dateFormatter.string(from: self)
    }
    
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
    
    func timeOfDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func stringFormatManual(formatPattern:String? = nil) -> String {
        
        guard let format = formatPattern else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = (formatPattern ?? "yyyy'-'MM'-'dd")
        
        var date = self
        
        if Language.current == .thai {
            date = self + 543.years
        }
        
        let result = String(format: format, date.day, date.month, date.year, date.hour, date.minute)
        
        return result
    }
    
    func fullDateAndTimeFormat() -> String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = Language.current == .thai ? "dd MMMM yyyy HH:mm น." : "MMM dd, YYYY 'at' HH:mm"
        newDateFormatter.locale = Language.current.locale
        newDateFormatter.timeZone = TimeZone(identifier: "Asia/Bangkok")
        return  newDateFormatter.string(from: self)
    }
    
    
    func month() -> String {
        var result = ""
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 7)
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: self)
        
        if let dateTime = dateFormatter.date(from: dateString) {
            
            dateFormatter.dateFormat = "MMM"
            result = dateFormatter.string(from: dateTime)
        }
        
        return result
    }
    
    func date() -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "THA")
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: self)
        
        if let dateTime = dateFormatter.date(from: dateString) {
            
            dateFormatter.dateFormat = "d"
            result = dateFormatter.string(from: dateTime)
        }
        
        return result
    }
    
    func day() -> String {
        var result = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "THA")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Language.current.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: self)
        
        if let dateTime = dateFormatter.date(from: dateString) {
            
            dateFormatter.dateFormat = "E"
            result = dateFormatter.string(from: dateTime)
        }
        
        return result
    }
    
    
    func convertDate(pattern: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func setTime( hours: Int, minutes: Int, seconds: Int) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateString = "\(dateFormatter.string(from: self)) \(hours):\(minutes):\(seconds)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: newDateString) ?? Date()
    }
    
    func setTime( hours: String?, minutes: String?, seconds: String?) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateString = "\(dateFormatter.string(from: self)) \(hours ?? "00"):\(minutes ?? "00"):\(seconds ?? "00")"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: newDateString) ?? Date()
    }
    
    func thTimeZoneDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Bangkok")
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func convertToThaiFormat(pattern: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "th_TH")
        dateFormatter.calendar = Calendar(identifier: .buddhist)
        dateFormatter.dateFormat = pattern
        return dateFormatter.string(from: self)
    }
    
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dtf.string(from: self)
    }
    
    func currentTimeZoneDateFormat(pattern: String) -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = pattern
        return dtf.string(from: self)
    }
    
    func currentTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "HH:mm"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func currentTimeStringWithCurrentLocalString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func isSameDay(with date: Date?) -> Bool {
        
        guard let date = date else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString1 = dateFormatter.string(from: date)
        let dateString2 = dateFormatter.string(from: self)
        
        if dateString1 == dateString2 {
            return true
        }
        
        return false
        
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func betweenBySec(date: Date) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .positional
        return formatter.string(from: date, to: Date()) ?? ""
    }
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        if day > 1 {
            if Language.current == .thai {
                return date.stringFormatThai(formatPattern: "dd MMM yyyy HH:mm น.")
            } else {
                return date.stringFormatThai(formatPattern: "MMM dd, YYYY 'at' HH:mm")
            }
        } else if day == 1 {
            if Language.current == .thai {
                return "\("Yesterday".localized) " + date.stringFormatThai(formatPattern: "HH:mm น.")
            } else {
                return "\("Yesterday".localized) " + date.stringFormatThai(formatPattern: "HH:mm")
            }
        } else if hour == 1 {
            return "\(hour) "+"hour ago".localized
        } else if hour > 1 {
            return "\(hour) "+"hours ago".localized
        } else if hour < 1 {
            if minute == 0 {
                return "just now".localized
            }
            if minute == 1 {
                return "\(minute) "+"A minute ago".localized
            }
            return "\(minute) "+"A minutes ago".localized
        }
        return ""
    }
    
    static func checkDate(fromDateString dateString:String,withFormat dateFormat:String = "YYYY-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 7*60*60)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.date(from: dateString)
    }
    
    static func getDate(fromDateString dateString:String,withFormat dateFormat:String = "YYYY-MM-dd HH:mm:ss") -> Date? {
        return Date.checkDate(fromDateString: dateString, withFormat: dateFormat) ?? nil
    }
    
    func convertDateWithProvidedTemplate(formatter: DateFormatPattern) -> String {
        return self.stringDateFormat(formatter.rawValue, timeZone: .asiaBangkok, locale: getCurrentLocale())
    }
    
    private func getCurrentLocale() -> Locales {
        return Language.current == .thai ? .thai : .english
    }
    
    func fullDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Language.current.locale
        dateFormatter.calendar = Calendar(identifier: Language.current == .english ? .gregorian : .buddhist)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    
    func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date) ?? Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        
        return arrDates.reversed()
    }
    
    func getDates(forNextNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date) ?? Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        
        return arrDates
    }
    
    func getTodayByFormat() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: date)
    }
    
    func relativeTimeWithCurrent() -> String {
        let date = self
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        if day > 1 {
            if Language.current == .thai {
                return date.stringFormatThai(formatPattern: "dd MMM yyyy HH:mm น.")
            } else {
                return date.stringFormatThai(formatPattern: "dd MMM yyy HH:mm")
            }
        } else if day == 1 {
            if Language.current == .thai {
                return "\("Yesterday".localized) " + date.stringFormatThai(formatPattern: "HH:mm น.")
            } else {
                return "\("Yesterday".localized) " + date.stringFormatThai(formatPattern: "HH:mm")
            }
        } else if hour == 1 {
            return "\(hour) "+"hour ago".localized
        } else if hour > 1 {
            return "\(hour) "+"hours ago".localized
        } else if hour < 1 {
            if minute == 0 {
                return "USER_INBOX_SECOND".localized
            }
            if minute == 1 {
                return "\(minute) "+"A minute ago".localized
            }
            return "\(minute) "+"A minutes ago".localized
        }
        return ""
    }
    
    func calculateDuration(fromDate date:Date) -> Int {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.second], from: date, to: self)
        let seconds = dateComponents.second
        guard let duration = seconds else { return 0 }
        return duration * 1000
    }
}


public extension DateFormatter {
    
    var isoFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            return dateFormatter
            
        }
    }
    
    var yearMonthDayFormatter: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return dateFormatter
            
        }
    }
    
    var footballDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
    
    class var footballDateSSSZFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }
    
    var footballDateWithZoneFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter
    }
    
    func getDateFormatter(_ patternFormat: String = "yyyy-MM-dd HH:mm:ss",
                          gmt: Int = 7,
                          identifier: Calendar.Identifier = .gregorian) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = patternFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: gmt)
        dateFormatter.calendar = Calendar(identifier: identifier)
        return dateFormatter
    }
}

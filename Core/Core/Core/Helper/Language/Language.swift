//
//  Language.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/5/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation

/**
 Application Level Configurations
 */

// MARK: - Language and Localization



/**
 Main Language enum, with current settings via
 
 Usage:
 Language.current
 
 Example:
 
 */
public enum Language {
    case thai
    case english
    
    var locale: Locale {
        switch self {
        case .thai:
            return Locale(identifier: "th_TH")
        case .english:
            return Locale(identifier: "en_US")
        }
    }
    
    var calendar: Calendar {
        switch self {
        case .thai:
            return Calendar(identifier: .buddhist)
        case .english:
            return Calendar(identifier: .gregorian)
        }
    }
    
    /**
     equivalident to "rawValue" ("th" or "en")
     */
    var name: String {
        switch self {
        case .thai:
            return "th"
        case .english:
            return "en"
        }
    }
    
    var title: String {
        switch self {
        case .thai:
            return "ไทย"
        case .english:
            return "English"
        }
    }
    
    static let thaiTableName = "LocalizedThai"
    static let englishTableName = "LocalizedEnglish"
    
    var tableName: String {
        switch self {
        case .thai:
            return Language.thaiTableName
        case .english:
            return Language.englishTableName
        }
    }
    
    static var languageCode: String {
        return Locale.current.languageCode ?? ""
    }
    
    static var current: Language = Language.languageCode == "th" ? .thai : .english {
        didSet {
            UserDefaults.standard.set(self.current.name, forKey: "AppLanguage")
            Notification.Name.LanguageDidChange.post()
        }
    }
    
    func relativeTime(of: Date, from: Date = Date()) -> String {
        let allSeconds = lround(of.timeIntervalSince(from))
        let isAgo = allSeconds < 0
        let absSeconds = abs(allSeconds)
        let hours = absSeconds / 3600
        let mins = (absSeconds % 3600) / 60
        let seconds = absSeconds % 60
        
        if isAgo {
            if hours > 0 {
                return String(format: "TIME_UNIT_HOURS %d AGO".localized, arguments: [hours])
            }
            if mins > 0 {
                return String(format: "TIME_UNIT_MINUTES %d AGO".localized, arguments: [mins])
            }
            if seconds > 0 {
                return String(format: "TIME_UNIT_SECONDS %d AGO".localized, arguments: [seconds])
            }
            return "TIME_UNIT_LESS_THAN_SECONDS AGO".localized
        } else {
            if hours > 0 {
                return String(format: "TIME_UNIT_HOURS %d IN".localized, arguments: [hours])
            }
            if mins > 0 {
                return String(format: "TIME_UNIT_MINUTES %d IN".localized, arguments: [mins])
            }
            if seconds > 0 {
                return String(format: "TIME_UNIT_SECONDS %d IN".localized, arguments: [seconds])
            }
            return "TIME_UNIT_LESS_THAN_SECONDS IN".localized
        }
    }
}

//
//  String+Language.swift
//  Core
//
//  Created by Komsit Chusangthong on 5/5/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//
/**
Convinience method to invoke the localized string via extension
*/

public extension String {
    var thai: String {
        return NSLocalizedString(self, tableName: Language.thaiTableName, bundle: .main, value: "", comment: "")
    }
    
    var english: String {
        return NSLocalizedString(self, tableName: Language.englishTableName, bundle: .main, value: "", comment: "")
    }
    
    /*
    var enThPair: EnThPair {
        return EnThPair(en: self.english, th: self.thai)
    }
     */
    
    var localized: String { return NSLocalizedString(self, tableName: Language.current.tableName, bundle: ConfigBundle.ghostNightMain, value: "", comment: "") }
    
    var localizedGhostNightPlayer: String { return NSLocalizedString(self, tableName: Language.current.tableName, bundle: ConfigBundle.ghostNightPlayer, value: "", comment: "") }
    
    var localizedComponent: String { return NSLocalizedString(self, tableName: Language.current.tableName, bundle: ConfigBundle.component, value: "", comment: "") }
    
}

public func checkUrlHeader(urlString: String) -> String {
    if urlString.hasPrefix("https://") || urlString.hasPrefix("http://") {
        return urlString
    } else {
        let correctedURL = "http://\(urlString)"
        return correctedURL
    }
}


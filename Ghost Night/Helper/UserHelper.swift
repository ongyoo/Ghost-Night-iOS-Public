//
//  UserHelper.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Component

enum StoreKey: String {
    case token = "user_token"
    
    // MARK :- User Detail
    case userName = "user_name"
    case userEmail = "user_email"
    case userCreateDate = "user_create_date"
    case userTimestamp = "user_timestamp"
    case userProfileAvatarURL = "user_profile_avatar_url"
    case userFacebookId = "user_facebook_id"
    case userIsFacebook = "user_is_facebook"
    case userRoleId = "user_role_id"
    case userRoleName = "user_role_name"
    
    
}

protocol UserHelperProtocol {
    func getToken() -> String?
    func isLoggedIn() -> Bool
    func getUserName() -> String?
    func getUserEmail() -> String?
    func getUserCreateDate() -> Date?
    func getUserTimestamp() -> Date?
    func getUserProfileAvatarURL() -> URL?
    func getUserFacebookId() -> String?
    func isFacebook() -> Bool
    func getUserRoleId() -> String?
}

class UserHelper: UserHelperProtocol {
    static let share = UserHelper()
    var user: SigninResponse?
    var viewModel = LoginViewModel()
    
    func getToken() -> String? {
        return StoreData.getData(key: .token) as? String
    }
    
    func isLoggedIn() -> Bool {
        return (self.getToken() == nil) ? true : false
    }
    
    func getUserName() -> String? {
        return StoreData.getData(key: .userName) as? String
    }
    
    func getUserEmail() -> String? {
        return StoreData.getData(key: .userEmail) as? String
    }
    
    func getUserCreateDate() -> Date? {
        return StoreData.getData(key: .userCreateDate) as? Date
    }
    
    func getUserTimestamp() -> Date? {
        return StoreData.getData(key: .userTimestamp) as? Date
    }
    
    func getUserProfileAvatarURL() -> URL? {
        guard let url = StoreData.getData(key: .userProfileAvatarURL) as? String else { return nil }
        return URL(string: url) ?? nil
    }
    
    func getUserFacebookId() -> String? {
        return StoreData.getData(key: .userFacebookId) as? String
    }
    
    func isFacebook() -> Bool {
        guard let isFacebook = StoreData.getData(key: .userIsFacebook) as? Bool else { return false }
        return isFacebook
    }
    
    func getUserRoleId() -> String? {
        return StoreData.getData(key: .userRoleId) as? String
    }
    
    func getUserRoleName() -> String? {
        return StoreData.getData(key: .userRoleName) as? String
    }
    
    // Set Token
    func setSiginUser(user: SigninResponse?) {
        StoreData.saveData(value: user?.userId, key: .token)
    }
    
    func setUserInfoUser(item: UserDetailResponse?) {
        StoreData.saveData(value: item?.userName, key: .userName)
        StoreData.saveData(value: item?.userEmail, key: .userEmail)
        StoreData.saveData(value: item?.userCreateDate, key: .userCreateDate)
        StoreData.saveData(value: item?.userTimestamp, key: .userTimestamp)
        StoreData.saveData(value: item?.userProfileAvatarURL?.absoluteString, key: .userProfileAvatarURL)
        StoreData.saveData(value: item?.userFacebookId, key: .userFacebookId)
        StoreData.saveData(value: item?.userIsFacebook, key: .userIsFacebook)
        StoreData.saveData(value: item?.userRoleId, key: .userRoleId)
        StoreData.saveData(value: item?.userRoleName, key: .userRoleName)
        
        if !(item?.userIsActive ?? false) && !isLoggedIn() {
            AlertHelper.alert(title: "ErrorAlertTitle".localized,
                              message: "ErrorUserNotActive".localized,
                              majorTitleButton: "AlertOK".localized,
                              majorButtonType: .danger) { self.signOut() }
        }
        
        Notification.Name.UserDidChange.post()
    }
    
    func syncUserInfo() {
        if let token = UserHelper.share.getToken(), token != "", !token.isEmpty {
            viewModel.input.userDetail()
        }
    }
    
    func signOut() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        Notification.Name.UserDidChange.post()
    }
}


class StoreData {
    static func saveData(value: Any?, key: StoreKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func getData(key: StoreKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}


//
//  UserAPI.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import Moya
import Data

enum UserAPI {
    case signIn(username: String, password: String)
    case userDetail(token: String)
    case signup(request: SignUpRequest)
    
    // Facebook
    case signInFb(facebookId: String)
    case signupFb(request: SignUpRequest)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .signIn, .userDetail, .signInFb, .signup, .signupFb:
            return BaseAPI.apiUrl
        }
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/user/signin"
        case .userDetail:
            return "/user/userDetail"
        case .signup:
            return "/user/signup"
        case .signInFb:
            return "/user/signin_facebook"
        case .signupFb:
            return "/user/signup_facebook"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .userDetail, .signup, .signInFb, .signupFb:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case  .signIn, .userDetail, .signInFb:
            return .requestPlain
            
        case let .signup(request):
            let jsonData = try? JSONSerialization.data(withJSONObject: request.toJSON())
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: request.toJSON()))
            
        case let .signupFb(request):
            let jsonData = try? JSONSerialization.data(withJSONObject: request.toJSON())
            return .requestData(jsonData ?? NSKeyedArchiver.archivedData(withRootObject: request.toJSON()))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .signIn(username, password):
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            let headers = ["Authorization": "Basic \(base64Credentials)", "Content-Type" : "application/json"]
            return headers
            
        case let .userDetail(token):
            let headers = ["Authorization": token, "Content-Type" : "application/json"]
            return headers
            
        case .signup, .signupFb:
            let headers = ["Content-Type" : "application/json"]
            return headers
            
        case let .signInFb(fbId):
            let headers = ["facebook-id": fbId, "Content-Type" : "application/json"]
            return headers
        }
    }
}



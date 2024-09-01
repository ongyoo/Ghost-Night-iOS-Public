//
//  UserRepository.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol UserRepository {
    func signin(username: String, password: String) -> Observable<SigninResponse>
    func signInFb(facebookId: String) -> Observable<SigninResponse>
    func userDetail(token: String) -> Observable<UserDetailResponse>
    func signup(request: SignUpRequest) -> Observable<SignUpResponse>
    func signupFb(request: SignUpRequest) -> Observable<SignUpResponse>
}

final class UserRepositoryImpl: UserRepository {
    private let userProvider = MoyaProvider<UserAPI>()
    
    func signin(username: String, password: String) -> Observable<SigninResponse> {
        return userProvider
            .rx
            .request(.signIn(username: username, password: password))
            .mapObject(SigninResponse.self)
            .asObservable()
    }
    
    func userDetail(token: String) -> Observable<UserDetailResponse> {
        return userProvider
            .rx
            .request(.userDetail(token: token))
            .mapObject(UserDetailResponse.self)
            .asObservable()
    }
    
    func signInFb(facebookId: String) -> Observable<SigninResponse> {
        return userProvider
            .rx
            .request(.signInFb(facebookId: facebookId))
            .mapObject(SigninResponse.self)
            .asObservable()
    }
    
    func signup(request: SignUpRequest) -> Observable<SignUpResponse> {
        return userProvider
            .rx
            .request(.signup(request: request))
            .mapObject(SignUpResponse.self)
            .asObservable()
    }
    
    func signupFb(request: SignUpRequest) -> Observable<SignUpResponse> {
        return userProvider
            .rx
            .request(.signupFb(request: request))
            .mapObject(SignUpResponse.self)
            .asObservable()
    }
}

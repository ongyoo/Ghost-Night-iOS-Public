//
//  FacebookRepository.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import FBSDKLoginKit
import ObjectMapper

protocol FaceBookRepository {
    func facebookLogin(target: UIViewController?) -> Observable<FacebookResponse>
}

final class FaceBookRepositoryImpl: FaceBookRepository {
    let fbLoginManager: LoginManager = LoginManager()
    
    func facebookLogin(target: UIViewController?) -> Observable<FacebookResponse> {
        let topVC = target ?? UIApplication.getTopViewController()
        
        return Observable.create{ (emitter) -> Disposable in
            self.fbLoginManager.logIn(permissions: ["email"], from: topVC) { (result, error) in
                if (error == nil) {
                    let fbloginresult : LoginManagerLoginResult = result!
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if(AccessToken.current != nil) {
                            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil), let objec = Mapper<FacebookResponse>().map(JSONObject: result) {
                                    emitter.onNext(objec)
                                    emitter.onCompleted()
                                } else {
                                    emitter.onError(error ?? SigninError.facebookError)
                                }
                            })
                        }
                        self.fbLoginManager.logOut()
                    }
                }
                if (error != nil) {
                    emitter.onError(error ?? SigninError.facebookError)
                }
            }
            return Disposables.create()
        }
    }
}


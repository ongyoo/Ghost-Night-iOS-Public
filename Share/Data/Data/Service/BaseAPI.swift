//
//  BaseAPI.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 4/23/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import RxSwift

public enum APIError : Error {
    case unknown
}

public class BaseAPI {
    //static let apiUrlString = "http://api.ghostnight.mobi/api"
    //static let apiUrl = URL(string: "http://api.ghostnight.mobi/api")!
    
    public static let apiUrlString = "http://ghostnight.mobi/api"
    //static let apiUrlString = "https://ghostnight.mobi/api"
    public static let apiUrl = URL(string: apiUrlString)!
    
    public func sendAPI<T: Mappable>(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding?, headers: HTTPHeaders?) -> Observable<T?> {
        return Observable.create({ (emitter) -> Disposable in
            Alamofire.request(url, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.default, headers: headers).validate(statusCode: 200...400).responseObject {(response: DataResponse<T>) in
                if case let .failure(error) = response.result {
                    emitter.onError(error)
                    return
                }
                emitter.onNext(response.result.value)
                emitter.onCompleted()
            }
            return Disposables.create()
        })
    }
    
    
    public func sendAuthenAPI<T: Mappable>(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding?, headers: HTTPHeaders?, username: String, password: String) -> Observable<T?> {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        return Observable.create({ (emitter) -> Disposable in
            Alamofire.request(url, method: method, parameters: parameters, encoding: encoding ?? URLEncoding.default, headers: headers).responseObject {(response: DataResponse<T>) in
                if case let .failure(error) = response.result {
                    emitter.onError(error)
                    return
                }
                emitter.onNext(response.result.value)
                emitter.onCompleted()
            }
            return Disposables.create()
        })
    }
}

//
//  RegisterViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/24/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

// Error
enum RegisterError: Error {
    case emailEmpty
    case passwordEmpty
    case passwordNotMatch
    case usernameEmpty
    
    var message: String {
        switch self {
        case .emailEmpty:
            return "ErrorRegisterEmail".localized
        case .passwordEmpty:
            return "ErrorRegisterPasswordMin8".localized
        case .passwordNotMatch:
            return "ErrorRegisterPasswordNotMatch".localized
        case .usernameEmpty:
            return "ErrorRegisterUsername".localized
        }
    }
}

protocol RegisterProtocolInput {
    func signUp(email: String?, password: String?, confrimPassword: String?, username: String?)
    func syncFacebook(facebook: FacebookResponse)
}

protocol RegisterProtocolOutput: class {
    
    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didRegisterSuccess: ((String) -> Void)? { get set }
    var didRegisterFbSuccess: ((String) -> Void)? { get set }
    var didError: ((Error) -> Void)? { get set }
    var didRxError: PublishSubject<Error> { get set }
    var didErrorCustom: ((String) -> Void)? { get set }
    
    // Function
    func getFacebookData() -> FacebookResponse?
    func isFacebook() -> Bool
    
}

protocol RegisterProtocol: RegisterProtocolInput, RegisterProtocolOutput {
    var input: RegisterProtocolInput { get }
    var output: RegisterProtocolOutput { get }
}

final class RegisterViewModel: RegisterProtocol, RegisterProtocolOutput {
    var input: RegisterProtocolInput { return self }
    
    var output: RegisterProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didRegisterSuccess: ((String) -> Void)?
    
    var didRegisterFbSuccess: ((String) -> Void)?
    
    var didError: ((Error) -> Void)?
    
    var didRxError: PublishSubject<Error> = PublishSubject<Error>()
    
    var didErrorCustom: ((String) -> Void)?
    
    // Function
    func getFacebookData() -> FacebookResponse? {
        return facebookData
    }
    
    func isFacebook() -> Bool {
        return ![nil, ""].contains(facebookData?.fbId) ? true : false
    }
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    fileprivate var facebookData: FacebookResponse?
    
    // UseCase
    fileprivate var signUpUseCase: SignUpUseCase!
    fileprivate var signUpFbUseCase: SignUpFbUseCase!
    
    init(signUpUseCase: SignUpUseCase? = SignUpUseCaseImpl(),
         signUpFbUseCase: SignUpFbUseCase? = SignUpFbUseCaseImpl()) {
        self.signUpUseCase = signUpUseCase
        self.signUpFbUseCase = signUpFbUseCase
    }
}

// MARK : - Input
extension RegisterViewModel: RegisterProtocolInput {
    func signUp(email: String?, password: String?, confrimPassword: String?, username: String?) {
        if (email?.isValidEmail ?? false) == false {
            didError?(RegisterError.emailEmpty)
            didRxError.onNext(RegisterError.emailEmpty)
            return
        }
        
        if (password?.count ?? 0) < 8 {
            didError?(RegisterError.passwordEmpty)
            didRxError.onNext(RegisterError.passwordEmpty)
            return
        }
        
        if (confrimPassword?.count ?? 0) < 8 {
            didError?(RegisterError.passwordEmpty)
            didRxError.onNext(RegisterError.passwordEmpty)
            return
        }
        
        if password != confrimPassword {
            didError?(RegisterError.passwordNotMatch)
            didRxError.onNext(RegisterError.passwordNotMatch)
            return
        }
        
        if username?.isEmpty ?? false {
            didError?(RegisterError.usernameEmpty)
            didRxError.onNext(RegisterError.usernameEmpty)
            return
        }
        
        var request = SignUpRequest()
        request.userEmail = email
        request.userPassword = password
        request.username = username
        if isFacebook() {
            let fbItem = getFacebookData()
            request.facebookId = fbItem?.fbId
            request.profileURL = fbItem?.pictureURL?.absoluteString
            signUpFacebook(request: request)
        } else {
            signUp(request: request)
        }
    }
    
    func syncFacebook(facebook: FacebookResponse) {
        facebookData = facebook
    }
    
    private func signUp(request: SignUpRequest) {
        showLoading?()
        signUpUseCase.execute(request: request)
            .subscribe(onNext: { [weak self] response in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading?()
                if response.status == 200 {
                    weakSelf.didRegisterSuccess?("\(response.dataMessage ?? "")กรุณากดเข้าระบบด้วยอีเมลอีกครั้ง")
                } else {
                    weakSelf.didErrorCustom?("เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง [\(response.message ?? "")][\(response.status ?? 0)]")
                }
                }, onError: { [weak self] error in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading?()
                    weakSelf.didError?(error)
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    private func signUpFacebook(request: SignUpRequest) {
        showLoading?()
        signUpFbUseCase.execute(request: request)
            .subscribe(onNext: { [weak self] response in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading?()
                if response.status == 200 {
                    weakSelf.didRegisterFbSuccess?("\(response.dataMessage ?? "")กรุณากดเข้าระบบด้วย facebook อีกครั้งเพื่อทำการเข้าสู่ระบบ")
                } else {
                    weakSelf.didErrorCustom?("เกิดข้อผิดพลาดกรุณาลองใหม่อีกครั้ง [\(response.message ?? "")][\(response.status ?? 0)]")
                }
                }, onError: { [weak self] error in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading?()
                    weakSelf.didError?(error)
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
}

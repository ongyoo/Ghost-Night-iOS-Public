//
//  LoginViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Core

// Error
enum SigninError: Error {
    case userNameEmpty
    case passwordEmpty
    case userpasswordEmpty
    case facebookError
    case someing
    
    var message: String {
        switch self {
        case .userNameEmpty:
            return "ErrorLoginUserNameEmpty".localized
        case .passwordEmpty:
            return "ErrorLoginPasswordEmpty".localized
        case .userpasswordEmpty:
            return "ErrorLoginUserNamePasswordNotFound".localized
        case .facebookError:
            return "ErrorUserFacebook".localized
        case .someing:
            return "ErrorSomeing".localized
        }
    }
}

protocol LoginProtocolInput {
    func signIn(username: String?, password: String?)
    func userDetail()
    func signInFacebookSDK(target: UIViewController?)
}

protocol LoginProtocolOutput: class {
    
    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didLoginSuccess: (() -> Void)? { get set }
    var didUserDetailSuccess: (() -> Void)? { get set }
    var didUserFacebookToRegister: ((FacebookResponse) -> Void)? { get set }
    var didError: ((Error) -> Void)? { get set }
    
    // Function
    
}

protocol LoginProtocol: LoginProtocolInput, LoginProtocolOutput {
    var input: LoginProtocolInput { get }
    var output: LoginProtocolOutput { get }
}

final class LoginViewModel: LoginProtocol, LoginProtocolOutput {
    
    var input: LoginProtocolInput { return self }
    var output: LoginProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didLoginSuccess: (() -> Void)?
    
    var didUserDetailSuccess: (() -> Void)?
    
    var didUserFacebookToRegister: ((FacebookResponse) -> Void)?
    
    var didError: ((Error) -> Void)?
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    private var signInUseCase: SignInUseCase!
    private var userDetailUseCase: UserDetailUseCase!
    private var facebooklUseCase: FaceBookUseCase!
    private var signInFbUseCase: SignInFbUseCase!
    
    init(signInUseCase: SignInUseCase? = SignInUseCaseImpl(),
         userDetailUseCase: UserDetailUseCase? = UserDetailUseCaseImpl(),
         facebooklUseCase: FaceBookUseCase? = FaceBookUseCaseImpl(),
         signInFbUseCase: SignInFbUseCase? = SignInFbUseCaseImpl()) {
        self.signInUseCase = signInUseCase
        self.userDetailUseCase = userDetailUseCase
        self.facebooklUseCase = facebooklUseCase
        self.signInFbUseCase = signInFbUseCase
    }
}

extension LoginViewModel: LoginProtocolInput {
    func signIn(username: String?, password: String?) {
        guard let username = username,
            let password = password else {
                //Error
                didError?(SigninError.userpasswordEmpty)
                return
        }
        
        if username == "", username.isValidEmail, username.isEmpty {
            didError?(SigninError.userNameEmpty)
            return
        }
        
        if password == "", password.isEmpty {
            didError?(SigninError.passwordEmpty)
            return
        }
        
        showLoading?()
        signInUseCase.execute(username: username, password: password)
            .subscribe(onNext: { [weak self] response in
                guard let weakSelf = self else { return }
                if let _ = response.userId {
                    // success
                    UserHelper.share.setSiginUser(user: response)
                    weakSelf.didLoginSuccess?()
                    weakSelf.userDetail()
                } else {
                    weakSelf.didError?(SigninError.someing)
                }
                weakSelf.hideLoading?()
                }, onError: { [weak self] error in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading?()
                    weakSelf.didError?(error)
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func userDetail() {
        guard let token = UserHelper.share.getToken() else {
            return
        }
        
        showLoading?()
        userDetailUseCase.execute(token: token)
            .subscribe(onNext: { [weak self] response in
                guard let weakSelf = self else { return }
                UserHelper.share.setUserInfoUser(item: response)
                weakSelf.didUserDetailSuccess?()
                weakSelf.hideLoading?()
                }, onError: { [weak self] error in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading?()
                    weakSelf.didError?(error)
                }, onDisposed: nil).disposed(by: self.disposeBag)
        
    }
    
    func signInFacebookSDK(target: UIViewController?) {
        showLoading?()
        facebooklUseCase.execute(target: target)
            .subscribe(onNext: { [weak self] response in
            guard let weakSelf = self else { return }
            weakSelf.signInFacebook(facebook: response)
            weakSelf.hideLoading?()
            }, onError: { [weak self] error in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading?()
                weakSelf.didError?(error)
            }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    private func signInFacebook(facebook: FacebookResponse?) {
        guard let fbItem = facebook, let facebookId = fbItem.fbId else { return }
        showLoading?()
        signInFbUseCase.execute(facebookId: facebookId)
            .subscribe(onNext: { [weak self] response in
            guard let weakSelf = self else { return }
                if let _ = response.userId {
                    // success
                    UserHelper.share.setSiginUser(user: response)
                    weakSelf.didLoginSuccess?()
                    weakSelf.userDetail()
                } else {
                    weakSelf.didUserFacebookToRegister?(fbItem)
                }
            weakSelf.hideLoading?()
            }, onError: { [weak self] error in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading?()
                weakSelf.didError?(error)
            }, onDisposed: nil).disposed(by: self.disposeBag)
    }
}


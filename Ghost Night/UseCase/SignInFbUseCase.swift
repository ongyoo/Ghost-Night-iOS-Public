//
//  SignInFbUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInFbUseCase {
    func execute(facebookId: String) -> Observable<SigninResponse>
}

final class SignInFbUseCaseImpl: SignInFbUseCase {
    private var userRepository: UserRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: UserRepository = UserRepositoryImpl()) {
        self.userRepository = repo
    }
    
    func execute(facebookId: String) -> Observable<SigninResponse> {
        return self.userRepository.signInFb(facebookId: facebookId)
    }
}

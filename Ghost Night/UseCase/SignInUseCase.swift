//
//  SiginInUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInUseCase {
    func execute(username: String, password: String) -> Observable<SigninResponse>
}

final class SignInUseCaseImpl: SignInUseCase {
    private var userRepository: UserRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: UserRepository = UserRepositoryImpl()) {
        self.userRepository = repo
    }
    
    func execute(username: String, password: String) -> Observable<SigninResponse> {
        return self.userRepository.signin(username: username, password: password)
    }
}

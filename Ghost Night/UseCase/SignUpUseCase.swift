//
//  SignUpUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

protocol SignUpUseCase {
    func execute(request: SignUpRequest) -> Observable<SignUpResponse>
}

final class SignUpUseCaseImpl: SignUpUseCase {
    private var userRepository: UserRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: UserRepository = UserRepositoryImpl()) {
        self.userRepository = repo
    }
    
    func execute(request: SignUpRequest) -> Observable<SignUpResponse> {
        return self.userRepository.signup(request: request)
    }
}
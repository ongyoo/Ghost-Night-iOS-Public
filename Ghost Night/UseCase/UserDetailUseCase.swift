//
//  UserDetailUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDetailUseCase {
    func execute(token: String) -> Observable<UserDetailResponse>
}

final class UserDetailUseCaseImpl: UserDetailUseCase {
    private var userRepository: UserRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: UserRepository = UserRepositoryImpl()) {
        self.userRepository = repo
    }
    
    func execute(token: String) -> Observable<UserDetailResponse> {
        return self.userRepository.userDetail(token: token)
    }
}

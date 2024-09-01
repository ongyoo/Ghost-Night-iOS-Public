//
//  FaceBookUseCase.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/23/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift

protocol FaceBookUseCase {
    func execute(target: UIViewController?) -> Observable<FacebookResponse>
}

final class FaceBookUseCaseImpl: FaceBookUseCase {
    private var faceBookRepository: FaceBookRepository!
    fileprivate var disposeBag = DisposeBag()
    
    init(repo: FaceBookRepository = FaceBookRepositoryImpl()) {
        self.faceBookRepository = repo
    }
    
    func execute(target: UIViewController?) -> Observable<FacebookResponse> {
        return faceBookRepository.facebookLogin(target: target)
    }
}

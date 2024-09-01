//
//  MainPlayListViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

protocol MainPlayListProtocolInput {
    func getShelfList()
    func getContentList(cmsId: String)
    func getMyPlayList(cmsId: String)
}

protocol MainPlayListProtocolOutput: class {

    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didError: ((Error) -> Void)? { get set }
    var didLoadShelfSuccess: (() -> Void)? { get set }
    var didLoadContentSuccess: (() -> Void)? { get set }
    
    // Function
    func getContentData() -> [ContentModel]

}

protocol MainPlayListProtocol: MainPlayListProtocolInput, MainPlayListProtocolOutput {
    var input: MainPlayListProtocolInput { get }
    var output: MainPlayListProtocolOutput { get }
}

final class MainPlayListViewModel: MainPlayListProtocol, MainPlayListProtocolOutput {
    
    var input: MainPlayListProtocolInput { return self }
    var output: MainPlayListProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didLoadShelfSuccess: (() -> Void)?
    
    var didLoadContentSuccess: (() -> Void)?
    
    var didError: ((Error) -> Void)?
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    fileprivate var shelfListUseCase: ShelfListUseCase?
    fileprivate var contentListUseCase: ContentListUseCase?
    fileprivate var myPlayListUseCase: MyPlayListUseCase?
    // Data
    fileprivate var contentData: [ContentModel] = []
    
    init(shelfListUseCase: ShelfListUseCase? = ShelfListUseCaseImpl(),
         contentListUseCase: ContentListUseCase? = ContentListUseCaseImpl(),
         myPlayListUseCase: MyPlayListUseCase? = MyPlayListUseCaseImpl()) {
        self.shelfListUseCase = shelfListUseCase
        self.contentListUseCase = contentListUseCase
        self.myPlayListUseCase = myPlayListUseCase
    }
    
    // Function
    func getContentData() -> [ContentModel] {
        return contentData
    }
}

extension MainPlayListViewModel: MainPlayListProtocolInput {
    func getShelfList() {
        showLoading?()
        shelfListUseCase?
            .execute(slug: .contentPlayList)
            .subscribe(onNext: { [weak self] response in
                guard let strongSelf = self else { return }
                var data = response.shelf?.compactMap({ (item) -> ContentModel in
                    return ContentModel(shelfItem: item,
                                        contentList: nil,
                                        isContentListLoaded: false,
                                        isLoading: false)
                }) ?? []
                data.removeAll(where: { $0.shelfItem?.slugType == nil })
                if !UserHelper.share.isLoggedIn() {
                    data.removeAll(where: { $0.shelfItem?.slugType == .nonLogin})
                } else {
                    data.removeAll(where: { $0.shelfItem?.slugType == .myPlayList })
                }
                strongSelf.contentData = data
                strongSelf.didLoadShelfSuccess?()
                strongSelf.hideLoading?()
        }, onError: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.didError?(error)
            strongSelf.hideLoading?()
        }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func getContentList(cmsId: String) {
        if let data = getContentByCmsId(cmsId: cmsId),
            data.isLoading && data.isContentListLoaded {
            return
        }
        updateFlagContent(cmsId: cmsId)
        showLoading?()
        contentListUseCase?
            .execute(cmsId: cmsId)
            .subscribe(onNext: { [weak self] response in
                guard let strongSelf = self else { return }
                strongSelf.updateContent(cmsId: cmsId,
                                         contents: response.contents, playList: nil)
                strongSelf.didLoadContentSuccess?()
                strongSelf.hideLoading?()
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.didError?(error)
                    strongSelf.hideLoading?()
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func getMyPlayList(cmsId: String) {
        guard let token = UserHelper.share.getToken() else { return }
        if let data = getContentByCmsId(cmsId: cmsId),
            data.isLoading && data.isContentListLoaded {
            return
        }
        updateFlagContent(cmsId: cmsId)
        showLoading?()
        
        myPlayListUseCase?
            .execute(cmsId: cmsId, token: token)
            .subscribe(onNext: { [weak self] response in
        guard let strongSelf = self else { return }
                strongSelf.updateContent(cmsId: cmsId, contents: nil,
                                         playList: response.contents)
        strongSelf.didLoadContentSuccess?()
        strongSelf.hideLoading?()
        }, onError: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.didError?(error)
            strongSelf.hideLoading?()
        }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    private func updateContent(cmsId: String, contents: [ContentItem]?, playList: [ContentPlayListItem]?) {
        if let index = contentData.firstIndex(where: {$0.shelfItem?.cmsId == cmsId}) {
            contentData[index].isLoading = false
            contentData[index].isContentListLoaded = true
            contentData[index].contentList = contents
            contentData[index].myPlayList = playList
        }
    }
    
    private func updateFlagContent(cmsId: String) {
        if let index = contentData.firstIndex(where: {$0.shelfItem?.cmsId == cmsId}) {
            contentData[index].isLoading = true
        }
    }
    
    private func getContentByCmsId(cmsId: String) -> ContentModel? {
        if let index = contentData.firstIndex(where: {$0.shelfItem?.cmsId == cmsId}) {
            return contentData[index]
        }
        return nil
    }
}


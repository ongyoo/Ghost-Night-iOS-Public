//
//  MainFeedViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/1/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

protocol MainFeedProtocolInput {
    func getShelfList()
    func getContentList(cmsId: String)
    func getContentListFreeDom(cmsId: String)
}

protocol MainFeedProtocolOutput: class {
    
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

protocol MainFeedProtocol: MainFeedProtocolInput, MainFeedProtocolOutput {
    var input: MainFeedProtocolInput { get }
    var output: MainFeedProtocolOutput { get }
}

final class MainFeedViewModel: MainFeedProtocol, MainFeedProtocolOutput {
    
    var input: MainFeedProtocolInput { return self }
    var output: MainFeedProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didLoadShelfSuccess: (() -> Void)?
    
    var didLoadContentSuccess: (() -> Void)?
    
    var didError: ((Error) -> Void)?
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()
    fileprivate var shelfListUseCase: ShelfListUseCase?
    fileprivate var contentListUseCase: ContentListUseCase?
    
    // Data
    fileprivate var contentData: [ContentModel] = []
    
    init(shelfListUseCase: ShelfListUseCase? = ShelfListUseCaseImpl(),
         contentListUseCase: ContentListUseCase? = ContentListUseCaseImpl()) {
        self.shelfListUseCase = shelfListUseCase
        self.contentListUseCase = contentListUseCase
    }
    
    // Function
    func getContentData() -> [ContentModel] {
        return contentData
    }
}

extension MainFeedViewModel: MainFeedProtocolInput {
    func getShelfList() {
        showLoading?()
        shelfListUseCase?
            .execute(slug: .contentFeed)
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
                                         contents: response.contents)
                strongSelf.didLoadContentSuccess?()
                strongSelf.hideLoading?()
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.didError?(error)
                    strongSelf.hideLoading?()
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    func getContentListFreeDom(cmsId: String) {
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
                strongSelf.updateContentFreeDom(cmsId: cmsId,
                                         contents: response.contents)
                strongSelf.didLoadContentSuccess?()
                strongSelf.hideLoading?()
                }, onError: { [weak self] error in
                    guard let strongSelf = self else { return }
                    strongSelf.didError?(error)
                    strongSelf.hideLoading?()
                }, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    private func updateContent(cmsId: String, contents: [ContentItem]?) {
        if let index = contentData.firstIndex(where: {$0.shelfItem?.cmsId == cmsId}) {
            contentData[index].isLoading = false
            contentData[index].isContentListLoaded = true
            contentData[index].contentList = contents
        }
    }
    
    private func updateContentFreeDom(cmsId: String, contents: [ContentItem]?) {
        if let index = contentData.firstIndex(where: {$0.shelfItem?.cmsId == cmsId}) {
            contentData[index].isLoading = false
            contentData[index].isContentListLoaded = true
            contentData[index].contentList = contents
            
            let masterItem = contentData[index]
            contentData.remove(at: index)
            for item in contents ?? [] {
                var data = masterItem
                data.contentItem = item
                contentData.append(data)
            }
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

//
//  ArticleDetailViewModel.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/1/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import RxSwift
import Data

protocol ArticleDetailProtocolInput {
    func updateViews()
}

protocol ArticleDetailProtocolOutput: class {
    
    // Loading
    var showLoading: (() -> Void)? { get set }
    var hideLoading: (() -> Void)? { get set }
    
    // Event
    var didError: ((Error) -> Void)? { get set }
    
    // Function
    func getContentData() -> ContentItem?
    func injectHTMLCSSIntoIframe(htmlContentHTML: String) -> String
    
}

protocol ArticleDetailProtocol: ArticleDetailProtocolInput, ArticleDetailProtocolOutput {
    var input: ArticleDetailProtocolInput { get }
    var output: ArticleDetailProtocolOutput { get }
}

final class ArticleDetailViewModel: ArticleDetailProtocol, ArticleDetailProtocolOutput {
    
    var input: ArticleDetailProtocolInput { return self }
    var output: ArticleDetailProtocolOutput { return self }
    
    var showLoading: (() -> Void)?
    
    var hideLoading: (() -> Void)?
    
    var didError: ((Error) -> Void)?
    
    // Get Only
    fileprivate var disposeBag = DisposeBag()

    
    // Data
    fileprivate var contentData: ContentItem? = nil
    fileprivate var viewerUseCase: UpdateContetViewerUseCase?
    
    init(content: ContentItem?,
         viewerUseCase: UpdateContetViewerUseCase? = UpdateContetViewerUseCaseImpl()) {
        self.contentData = content
        self.viewerUseCase = viewerUseCase
    }
    
    // Function
    func getContentData() -> ContentItem? {
        return contentData ?? nil
    }
    
    func injectHTMLCSSIntoIframe(htmlContentHTML: String) -> String {
        let responsiveCssFile = Bundle.main.url(forResource: "responsive", withExtension:"css")!
        let jqueryJsFile      = Bundle.main.url(forResource: "jquery-3.1.1.min", withExtension:"js")!
        let responsiveJsFile  = Bundle.main.url(forResource: "responsive", withExtension:"js")!
        

        let html = "<html>" +
            "<style type=\"text/css\">" +
            "body {" +
            "font-family: Sukhumvit Set;" +
            //"background-color: #EEEEF0;" +
            "}" +
            "</style>" +
            "<head>" +
            "<link rel=\"stylesheet\" type=\"text/css\" href=\"\(responsiveCssFile)\">" +
            "<script src=\"\(jqueryJsFile)\"></script>" +
            "<script src=\"\(responsiveJsFile)\"></script>" +
            "</head>" +
            "<body leftmargin=\"8\" rightmargin=\"8\" style=\"font-size:30px; margin-top:-0%\">" +
            //"<div class=\"content-header\">" +
           // "<img src=\"\(renderThumnail())\"/>" +
            //"<div class=\"content-title\"><h1>\(renderTitle())</h1></div>" +
            //"</div>" +
            "<div class=\"content-body\" >" +
            "<span class=\"meta-content-block\">" +
            //"\(infoHTML)" +
            "</span>" +
            "\(htmlContentHTML)" +
            "</div>" +
        "</body></html>"
     return html
    }
}

extension ArticleDetailViewModel: ArticleDetailProtocolInput {
    func updateViews() {
        if let cmsId = self.contentData?.cmsId {
            viewerUseCase?.execute(cmsId: cmsId).subscribe(onNext: { response in
                
            }, onError: { error in
                
            }, onDisposed: nil).disposed(by: self.disposeBag)
        }
    }
}

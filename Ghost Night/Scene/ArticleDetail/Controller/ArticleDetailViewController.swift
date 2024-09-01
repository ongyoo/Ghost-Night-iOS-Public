//
//  ArticleDetailViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/1/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import WebKit
import Component
import Core

final class ArticleDetailViewController: UIViewController {
    @IBOutlet fileprivate weak var headerView: UIView!
    @IBOutlet fileprivate weak var webView: WKWebView!
    @IBOutlet fileprivate weak var bannerImageView: UIImageView!
    @IBOutlet fileprivate weak var bgNavView: UIView!
    @IBOutlet fileprivate weak var viewerLabel: UILabel!
    @IBOutlet fileprivate weak var titleNavLabel: UILabel!
    // Constraint
    @IBOutlet fileprivate weak var headerTopConstraint: NSLayoutConstraint!
    // Loading
    fileprivate var loadingScreen: LoadingScreen!
    // content Off set
    fileprivate var oldContentOffset = CGPoint.zero
    fileprivate var alpha: Float = 0.0
    
    //ViewModel
    fileprivate var viewModel: ArticleDetailProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpWebView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.updateViews()
    }
    
    // MARK: - Config
    func config(viewModel: ArticleDetailProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK :- SetUp
    private func setUp() {
        loadingScreen = LoadingScreen(frame: self.view.bounds)
        viewerLabel.text = "\(viewModel.output.getContentData()?.viewer?.formatNumber() ?? "0") วิว"
        titleNavLabel.text = viewModel.output.getContentData()?.title
    }
    
    private func setUpWebView() {
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        //webView.scrollView.bounces = false
        
        if let content = viewModel.output.getContentData(), let html = content.contentArticleHtml {
            sendRequestHtmlString(html: viewModel.output.injectHTMLCSSIntoIframe(htmlContentHTML: html))
            if let image = content.contentArticleMedia?.first {
                bannerImageView.sd_setImage(with: image, placeholderImage: UIImage(named: "ic_logo"))
            }
        }
    }
    
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func sendRequestHtmlString(html: String) {
        showLoading()
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    // MARK :- Action
    @IBAction func fontReSizeAction(_ sender: UIButton) {
        let textSize: Int = sender.isSelected ? 30 : 50
        //"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%%'"
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.fontSize = '\(textSize)px'") { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            if error != nil {
                debugPrint(error.debugDescription)
            }
            weakSelf.webView.reload()
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let content = viewModel.output.getContentData()
        let shareDialog = ShareDialogViewController()
        let shareContent = ShareModel(hashtag: "#GhostNight",
                                      pageID: "113227676884200",
                                      contentURL: URL(string: "https://www.facebook.com/113227676884200")!,
                                      quote: "[Beta 0.0.1] [\(content?.title ?? "")] \(content?.detail ?? "")").convertToShareLinkContent()
        shareDialog.showShareDialog(self, content: shareContent, mode: .automatic)
    }
}

// MARK :- BindViewModel
fileprivate extension ArticleDetailViewController {
    func bindViewModel() {

    }
    
    func showLoading() {
        loadingScreen.attach(hostView: self.view)
    }
    
    func hideLoading() {
        loadingScreen.hideAndStop()
    }
    
    func didError(error: Error) {
        AlertHelper.alert(title: "ErrorTitle".localized,
                          message: error.localizedDescription,
                          majorTitleButton: "AlertOK".localized,
                          majorButtonType: .danger,
                          majorAction: nil)
    }
}

// MARK :- WKNavigationDelegate
extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Set the indicator everytime webView started loading
        //self.setActivityIndicator()
        //self.showActivityIndicator(show: true)
        hideLoading()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
        didError(error: error)
    }
    
}

// MARK :- UIScrollViewDelegate
extension ArticleDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //validateScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //validateScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //validateScroll(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        validateScroll(scrollView)
        if (scrollView.contentOffset.y > 65) {
            bgNavView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else if (scrollView.contentOffset.y < 20) {
            bgNavView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        }
    }
    
    // MARK :- Zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

extension ArticleDetailViewController {
    fileprivate func validateScroll(_ scrollView: UIScrollView) {
        let contentOffset =  scrollView.contentOffset.y - oldContentOffset.y
        // Scrolls UP - we compress the top view
        if contentOffset > 0 && scrollView.contentOffset.y > 0 {
            if (headerTopConstraint.constant > -210) {
                headerTopConstraint.constant -= contentOffset
                scrollView.contentOffset.y -= contentOffset
                alpha += 0.05
            }
        }
        
        // Scrolls Down - we expand the top view
        if contentOffset < 0 && scrollView.contentOffset.y < 0 {
            if (headerTopConstraint.constant < 0) {
                if headerTopConstraint.constant - contentOffset > 0 {
                    headerTopConstraint.constant = 0
                    alpha = 0.0
                } else {
                    headerTopConstraint.constant -= contentOffset
                    alpha -= 0.1
                }
                scrollView.contentOffset.y -= contentOffset
            }
        }
        oldContentOffset = scrollView.contentOffset
        bgNavView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: CGFloat(alpha))
        titleNavLabel.alpha = CGFloat(alpha)
    }
    
    private func isScrollUp(_ scrollView: UIScrollView) -> Bool {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            return false
        }
        self.alpha = 1.0
        return true
    }
    
    func validateBackToTopButtonInLatestFeed(topVisibleIndex: Int) {
        if topVisibleIndex < 3 {
            //hide()
        } else {
            //show()
            self.alpha = 1.0
        }
    }
}


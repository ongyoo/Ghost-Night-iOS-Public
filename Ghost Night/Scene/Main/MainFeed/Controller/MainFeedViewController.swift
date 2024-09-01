//
//  MainFeedViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Core
import Component
import Data

final class MainFeedViewController: BaseViewController {
    @IBOutlet fileprivate weak var headerView: MainHeaderView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let refreshControl = UIRefreshControl()
    
    //ViewModel
    fileprivate lazy var viewModel: MainFeedProtocol = {
        return MainFeedViewModel()
    }()
    
    // Loading
    fileprivate var loadingScreen: LoadingScreen!
    
    // MARK :- Life Cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpRefreshControl()
        registerNotification()
        registerCell()
        bindViewModel()
        viewModel.input.getShelfList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setText()
    }
    
    // MARK: - Config
    func config(viewModel: MainFeedProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK :- SetUp
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .LanguageDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .UserDidChange, object: nil)
    }
    
    private func setUp() {
        setText()
        loadingScreen = LoadingScreen(frame: self.view.bounds)
        headerView.delegate = self
        headerView.setAvatarHiden()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    // MARK :- Register Cell
    private func registerCell() {
        tableView.register(UINib(nibName: NonLoginShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NonLoginShelfTableViewCell.identifier)
        tableView.register(UINib(nibName: HorizontalFirstShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HorizontalFirstShelfTableViewCell.identifier)
        tableView.register(UINib(nibName: HorizontalSecondShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HorizontalSecondShelfTableViewCell.identifier)
        tableView.register(UINib(nibName: ContentFreeDomLoadingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ContentFreeDomLoadingTableViewCell.identifier)
        tableView.register(UINib(nibName: ContentFreeDomTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ContentFreeDomTableViewCell.identifier)
    }
    
    private func setUpRefreshControl() {
        refreshControl.backgroundColor = .white
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        // Code to refresh table view
        viewModel.input.getShelfList()
    }
    
    @objc private func setText() {
        headerView.reload()
        headerView.setTitle(string: "TitleMainFeed".localized)
    }
    
    
    // MARK :- Private
}

// MARK :- BindViewModel
fileprivate extension MainFeedViewController {
    func bindViewModel() {
        viewModel.output.showLoading = showLoading
        viewModel.output.hideLoading = hideLoading
        viewModel.output.didLoadShelfSuccess = didLoadShelfSuccess
        viewModel.output.didLoadContentSuccess = didLoadContentSuccess
        viewModel.output.didError = didError
    }
    
    func showLoading() {
        loadingScreen.attach(hostView: self.view)
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
        loadingScreen.hideAndStop()
    }
    
    func didLoadShelfSuccess() {
        /*
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        tableView.endUpdates()
         */
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func didLoadContentSuccess() {
//        let range = NSMakeRange(0, self.tableView.numberOfSections)
//        let sections = NSIndexSet(indexesIn: range)
//        self.tableView.reloadSections(sections as IndexSet, with: .fade)
        tableView.reloadData()
    }
    
    func didError(error: Error) {
        AlertHelper.alert(title: "ErrorTitle".localized,
                          message: error.localizedDescription,
                          majorTitleButton: "AlertOK".localized,
                          majorButtonType: .danger,
                          majorAction: nil)
    }
}

// MARK :- UITableViewDelegate
extension MainFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getContentData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.output.getContentData()[safe: indexPath.row]
        switch item?.shelfItem?.slugType {
        case .nonLogin?:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NonLoginShelfTableViewCell.identifier) as? NonLoginShelfTableViewCell {
                cell.delegate = self
                return cell
            }
        case .freedom?:
            if item?.isContentListLoaded ?? false {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ContentFreeDomTableViewCell.identifier) as? ContentFreeDomTableViewCell {
                    cell.delegate = self
                    cell.rander(content: item)
                    return cell
                }
            } else {
                // Loading
                if let cell = tableView.dequeueReusableCell(withIdentifier: ContentFreeDomLoadingTableViewCell.identifier) as? ContentFreeDomLoadingTableViewCell {
                    cell.delegate = self
                    cell.rander(content: item)
                    return cell
                }
            }
            
        default:
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalFirstShelfTableViewCell.identifier) as? HorizontalFirstShelfTableViewCell {
                    cell.delegate = self
                    cell.setHeader(item: item)
                    return cell
                }
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalSecondShelfTableViewCell.identifier) as? HorizontalSecondShelfTableViewCell {
                cell.delegate = self
                cell.setHeader(item: item)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = viewModel.output.getContentData()[safe: indexPath.row],
            let content = item.contentItem,
            let type = item.shelfItem?.slugType {
            switch type {
            case .freedom:
                didSelect(content: content)
            default: break
            }
        }
    }
}

// MARK :- Public
extension MainFeedViewController {
    
}

// MARK :- internal
fileprivate extension MainFeedViewController {
    
}


extension MainFeedViewController: MainHeaderDelegate {
    func didTapAvatar() {
        
    }
}

// MARK :- NonLoginShelfDelegate
extension MainFeedViewController: NonLoginShelfDelegate {
    func didTapLoginAction(_ sender: UIButton) {
        //NavigationManager.presentViewController(to: .login(self))
        NavigationManager().presentViewController2(to: .login(self))
        self.tableView.reloadData()
    }
    
    func didTapRegisterAction(_ sender: UIButton) {
        NavigationManager.presentViewController(to: .register(self, nil))
    }
    
    func presentModalViewController() {
        let modal = LoginViewController.instantiateFromAppStoryboard(appStoryboard: .Login)
        transitionDelegate.storkDelegate = self
        transitionDelegate.confirmDelegate = modal
        modal?.transitioningDelegate = transitionDelegate
        modal?.modalPresentationStyle = .custom
        self.present(modal!, animated: true, completion: nil)
    }
}

// MARK :- HorizontalFirstShelfDelegate, HorizontalSecondShelfDelegate
extension MainFeedViewController: HorizontalFirstShelfDelegate, ContentFreeDomLoadingDelegate, ContentFreeDomDelegate {
    
    func sheardAction(_ sender: UIButton, content: ContentModel) {
        let shareDialog = ShareDialogViewController()
        let shareContent = ShareModel(hashtag: "#GhostNight",
                                      pageID: "113227676884200",
                                      contentURL: URL(string: "https://www.facebook.com/113227676884200")!,
                                      quote: "[Beta 0.0.1] [\(content.contentItem?.title ?? "")] \(content.contentItem?.detail ?? "")").convertToShareLinkContent()
        shareDialog.showShareDialog(self, content: shareContent, mode: .automatic)
    }
    
    func addPlayListAction(_ sender: UIButton, content: ContentModel) {
        
    }
    
    func didSelectContentPlayList(content: ContentPlayListItem) {
        NavigationManager.presentViewController(to: .playList(self))
    }
    
    func didSelect(content: ContentItem) {
        if [.audio, .live].contains(content.contentType) {
            NavigationManager.presentViewController(to: .audioPlayer(content, self))
        } else {
            NavigationManager.pushViewController(to: .articleDetail(content, self))
        }
    }
    
    func requestContent(cmsId: String, type: ShelfSlug) {
        if type == .freedom {
            viewModel.input.getContentListFreeDom(cmsId: cmsId)
        } else {
            viewModel.input.getContentList(cmsId: cmsId)
        }
    }
}

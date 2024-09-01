//
//  MainPlayListViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Core
import Component
import Data

final class MainPlayListViewController: BaseViewController {
    @IBOutlet fileprivate weak var headerView: MainHeaderView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let refreshControl = UIRefreshControl()
    //ViewModel
    fileprivate lazy var viewModel: MainPlayListProtocol = {
        return MainPlayListViewModel()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Config
    func config(viewModel: MainPlayListProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK :- SetUp
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .LanguageDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .UserDidChange, object: nil)
    }
    
    private func setUp() {
        loadingScreen = LoadingScreen(frame: self.view.bounds)
        headerView.delegate = self
        setText()
        userProfileAvatarURL()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100.0))
    }
    
    private func setUpRefreshControl() {
        refreshControl.backgroundColor = .white
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        // Code to refresh table view
        userProfileAvatarURL()
        viewModel.input.getShelfList()
    }
    
    // MARK :- Register Cell
    private func registerCell() {
        tableView.register(UINib(nibName: NonLoginShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NonLoginShelfTableViewCell.identifier)
        tableView.register(UINib(nibName: HorizontalFirstShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HorizontalFirstShelfTableViewCell.identifier)
        tableView.register(UINib(nibName: HorizontalSecondShelfTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HorizontalSecondShelfTableViewCell.identifier)
    }
    
    private func userProfileAvatarURL() {
        if !UserHelper.share.isLoggedIn() {
            if let url = UserHelper.share.getUserProfileAvatarURL() {
                headerView.setAvatarImage(url: url)
            }
        } else {
            headerView.setAvatarDefault()
        }
    }
    
    @objc private func setText() {
        headerView.setTitle(string: "TitleMainPlayList".localized)
    }
}

// MARK :- UITableViewDelegate
extension MainPlayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getContentData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.output.getContentData()[indexPath.row]
        switch item.shelfItem?.slugType {
        case .nonLogin?:
             if let cell = tableView.dequeueReusableCell(withIdentifier: NonLoginShelfTableViewCell.identifier) as? NonLoginShelfTableViewCell {
                       cell.delegate = self
                       return cell
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
}

// MARK :- BindViewModel
fileprivate extension MainPlayListViewController {
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
        tableView.reloadData()
    }
    
    func didLoadContentSuccess() {
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

// MARK :- MainHeaderDelegate
extension MainPlayListViewController: MainHeaderDelegate {
    func didTapAvatar() {
        if !UserHelper.share.isLoggedIn() {
            // Login
            NavigationManager.presentViewController(to: .profile(self))
        } else {
            // Nonlogin
            AlertHelper.alert(title: "ErrorAlertTitle".localized, message: "ErrorNonlogin".localized, majorTitleButton: "AlertOK".localized, majorButtonType: .primary, minorTitleButton: "AlertCancel".localized, minorButtonType: .danger, majorAction: {
                //NavigationManager.presentViewController(to: .login(self))
                NavigationManager().presentViewController2(to: .login(self))
            }, minorAction: nil)
        }
    }
}

// MARK :- NonLoginShelfDelegate
extension MainPlayListViewController: NonLoginShelfDelegate {
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

// MARK :- HorizontalFirstShelfDelegate
extension MainPlayListViewController: HorizontalFirstShelfDelegate {
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
        if type == .myPlayList {
            viewModel.input.getMyPlayList(cmsId: cmsId)
        } else {
            viewModel.input.getContentList(cmsId: cmsId)
        }
    }
}

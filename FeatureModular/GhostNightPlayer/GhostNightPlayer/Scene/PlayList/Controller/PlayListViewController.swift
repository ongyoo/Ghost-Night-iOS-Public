//
//  PlayListViewController.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-06-07.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import SPStorkController
import Core

final public class PlayListViewController: BaseViewController {
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var playListImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    // Hander
    private let sectionHanderView = PlayListHeaderView.loadNib()
    // Ads View
    @IBOutlet private weak var adsView: UIView!
    @IBOutlet private weak var adsHeightConstraint: NSLayoutConstraint!
    
    // MARK :- Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCell()
    }
    
    //MARK :- Setup
    private func setup() {
        sectionHanderView.delegate = self
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: PlayListItemTableViewCell.identifier, bundle: AppStoryboard.PlayList.bundleId),
                           forCellReuseIdentifier: PlayListItemTableViewCell.identifier)
    }
    
    // MARK :- Action
    @IBAction private func closeAction(_ sender: UIButton) {
        dismissAction(completion: nil)
    }
    
    @IBAction private func editAction(_ sender: UIButton) {
        debugPrint("editAction")
    }
}

// MARK :-
extension PlayListViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        debugPrint("sectionHanderView : \(sectionHanderView)")
        sectionHanderView.setTitle(text: "ทดสอบข้อมูล")
        return sectionHanderView
    }
   
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayListItemTableViewCell.identifier, for: indexPath) as? PlayListItemTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK :- PlayListHeaderDelegate
extension PlayListViewController: PlayListHeaderDelegate {
    public func playAction(_ sender: UIButton) {
        debugPrint("Play List Action")
    }
}

extension PlayListViewController: SPStorkControllerConfirmDelegate {
    public var needConfirm: Bool {
        return false
    }
    
    public func confirm(_ completion: @escaping (Bool) -> ()) {
        completion(true)
    }
}


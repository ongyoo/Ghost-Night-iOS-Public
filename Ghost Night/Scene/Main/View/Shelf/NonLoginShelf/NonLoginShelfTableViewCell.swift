//
//  NonLoginShelfTableViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/5/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit

protocol NonLoginShelfDelegate {
    func didTapLoginAction(_ sender: UIButton)
    func didTapRegisterAction(_ sender: UIButton)
}

final class NonLoginShelfTableViewCell: UITableViewCell {
    static let identifier = "NonLoginShelfTableViewCell"
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    var delegate: NonLoginShelfDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    // MARK :- Setup
    private func setUp() {
        messageLabel.text = "NonLoginMessageTableViewCell".localized
        loginButton.setTitle("TitleLoginButtonTableViewCell".localized, for: .normal)
        registerButton.setTitle("TitleRegisterButtonTableViewCell".localized, for: .normal)
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16.0)
        loginButton.cornerRadius(cornerRadius: 22.0)
        registerButton.cornerRadius(cornerRadius: 22.0)
    }
    
    // MARK :- Action
    @IBAction private func loginAction(_ sender: UIButton) {
        delegate?.didTapLoginAction(sender)
    }
    
    @IBAction private func registerAction(_ sender: UIButton) {
        delegate?.didTapRegisterAction(sender)
    }
}

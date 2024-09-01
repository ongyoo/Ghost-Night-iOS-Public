//
//  UIHeaderShelfView.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/8/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Reusable

protocol UIHeaderShelfViewDelegate {
    func seemoreAction()
    func addPlayListAction()
}

class UIHeaderShelfView: UIView, NibOwnerLoadable {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seemoreButton: UIButton!
    @IBOutlet weak var addPlayListButton: UIButton!
    @IBOutlet weak var iconLeading: NSLayoutConstraint!
    
    // Store
    private var currentType: HeaderType = .hide
    enum HeaderType {
        case seemore
        case addPlayList
        case all
        case hide
    }
    
    //Delegate
    var delegate: UIHeaderShelfViewDelegate?
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
        setUpAddPlayListButton()
    }
    
    // MARK :- Set
    func setIcon(image: UIImage? = nil, url: URL? = nil) {
        iconLeading.constant = 20
        if let image = image {
            iconImageView.image = image
            return
        }
        
        if let url = url {
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_logo"))
            return
        }
        
        iconLeading.constant = -24
    }
    
    func setTitleLabel(string: String?) {
        titleLabel.text = string
    }
    
    func setSeeMoreType(type: HeaderType) {
        currentType = type
    }
    
    private func setView() {
        titleLabel.textColor = .black
        
        seemoreButton.setTitle("HeaderShelfViewSeeMoreButton".localized, for: .normal)
        addPlayListButton.setTitle("HeaderShelfViewAddPlayListButton".localized, for: .normal)
        switch currentType {
        case .addPlayList:
            seemoreButton.isHidden = true
        case .seemore:
            addPlayListButton.isHidden = true
        case .all:
            seemoreButton.isHidden = false
            addPlayListButton.isHidden = false
        case .hide:
            seemoreButton.isHidden = true
            addPlayListButton.isHidden = true
        }
    }
    
    private func setUpAddPlayListButton() {
        addPlayListButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addPlayListButton.layer.borderWidth = 1.0
        addPlayListButton.layer.borderColor = UIColor.black.cgColor
        addPlayListButton.cornerRadius(cornerRadius: (addPlayListButton.bounds.size.height / 2.0) - 3.5)
    }
    
    // MARK :- Action
    @IBAction func seemoreAction(_ sender: UIButton) {
        delegate?.seemoreAction()
    }
    
    @IBAction func addPlayListAction(_ sender: UIButton) {
        delegate?.addPlayListAction()
    }
}


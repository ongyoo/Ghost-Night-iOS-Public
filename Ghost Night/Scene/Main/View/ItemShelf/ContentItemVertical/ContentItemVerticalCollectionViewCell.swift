//
//  ContentItemVerticalCollectionViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/9/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Core
import Data

final class ContentItemVerticalCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentItemVerticalCollectionViewCell"
    @IBOutlet fileprivate weak var bgView: UIView!
    @IBOutlet fileprivate weak var thubnailImageView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var detailLabel: UILabel!
    @IBOutlet fileprivate weak var userNameLabel: UILabel!
    @IBOutlet fileprivate weak var updateDateLabel: UILabel!
    @IBOutlet fileprivate weak var iconPlayImageView: UIImageView!
    
    // Store
    private var currentContent: ContentItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func rander(content: ContentItem?) {
        if let thumbnailURL = content?.thumbnailURL {
            thubnailImageView.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "ic_logo"))
        }

        if let title = content?.title {
            titleLabel.text = title
        }
        
        if let detail = content?.detail {
            detailLabel.text = detail
        }
        
        if let userName = content?.userName {
            userNameLabel.text = String(format: "ContentItemVerticallUserName %@".localized, userName)
        }
        
        if let updateDate = content?.updateDate {
            updateDateLabel.text = String(format: "ContentItemVerticalUpdateTitlte %@".localized,
                                          updateDate.stringFormat(formatPattern: "dd/MM/YYYY"))
            
            
        }
        
        if let type = content?.contentType {
            switch type {
            case .content:
                iconPlayImageView.isHidden = true
            default:
                iconPlayImageView.isHidden = false
            }
        }
        
        currentContent = content
        //bgView.stopShimmering()
    }
    
    // SetUp
    private func setup() {
        titleLabel.textColor = .black
        detailLabel.textColor = .black
        userNameLabel.textColor = .black
        updateDateLabel.textColor = .black
        
        bgView.cornerRadius(cornerRadius: 10.0)
        self.cornerRadius(cornerRadius: 10.0)
        self.dropShadow(color: UIColor.black,
                   opacity: 0.4, offSet: CGSize(width: 0, height: 4),
                   radius: 3,
                   scale: true)
        
        thubnailImageView.cornerRadius(cornerRadius: 10.0)
    }
}

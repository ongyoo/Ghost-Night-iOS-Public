//
//  ContentFreeDomLoadingTableViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 1/19/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Data

protocol ContentFreeDomLoadingDelegate {
    func requestContent(cmsId: String, type: ShelfSlug)
    func didSelect(content: ContentItem)
}

final class ContentFreeDomLoadingTableViewCell: UITableViewCell {
    static let identifier = "ContentFreeDomLoadingTableViewCell"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var thumbnilImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // Store
    private var currentContent: ContentModel? {
        didSet {
            getContent()
        }
    }
    
    // Delegate
    var delegate: ContentFreeDomLoadingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func rander(content: ContentModel?) {
        self.currentContent = content
    }

    // SetUp
    private func setup() {

        bgView.cornerRadius(cornerRadius: 10.0)
        self.cornerRadius(cornerRadius: 10.0)
        self.dropShadow(color: UIColor.gray,
                   opacity: 0.4, offSet: CGSize(width: 0, height: 2),
                   radius: 10.0,
                   scale: true)
        
    }
    
    private func getContent() {
        if let item = currentContent, let cmsId = item.shelfItem?.cmsId, !item.isContentListLoaded && !item.isLoading {
            delegate?.requestContent(cmsId: cmsId, type: item.shelfItem?.slugType ?? ShelfSlug.unknown)
        }
    }
}

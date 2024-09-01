//
//  ContentFreeDomTableViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 1/19/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Data

protocol ContentFreeDomDelegate {
    func requestContent(cmsId: String, type: ShelfSlug)
    func didSelect(content: ContentItem)
    func sheardAction(_ sender: UIButton, content: ContentModel)
    func addPlayListAction(_ sender: UIButton, content: ContentModel)
}

final class ContentFreeDomTableViewCell: UITableViewCell {
    static let identifier = "ContentFreeDomTableViewCell"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var thumbnilImageView: UIImageView!
    @IBOutlet weak var iconPlayImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var sheardView: UISheardView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var iconLocationImageView: UIImageView!
    
    // Store
    private var currentContent: ContentModel? {
        didSet {
            getContent()
        }
    }
    
    // Delegate
    var delegate: ContentFreeDomDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func rander(content: ContentModel?) {
        self.currentContent = content
        
        if let thumbnailURL = content?.contentItem?.thumbnailURL {
            thumbnilImageView.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "ic_logo"))
        }
        let tag: [String] = [content?.contentItem?.contentTypeString ?? "unknown", content?.contentItem?.title ?? "unknown"]
        iconPlayImageView.isHidden = (content?.contentItem?.contentType == .content) ? true : false
        tagLabel.text = tag.joined(separator: ", ")
        userNameLabel.text = content?.contentItem?.userName ?? "unknown"
        updateLabel.text = content?.contentItem?.updateDate?.stringFormat(formatPattern: "dd/MM/YYYY")
        detailLabel.text = "\"\(content?.contentItem?.title ?? "unknown")\" \(content?.contentItem?.detail ?? "")"
        viewsLabel.text = "\((content?.contentItem?.viewer ?? "0").formatNumber()) จำนวนผู้เข้าชม"
        locationNameLabel.text = content?.contentItem?.county
    }

    // SetUp
    private func setup() {
        sheardView.delegate = self
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

extension ContentFreeDomTableViewCell: UISheardViewDelegate {
    func sheardAction(_ sender: UIButton) {
        if let content = currentContent {
            delegate?.sheardAction(sender, content: content)
        }
    }
    
    func addPlayListAction(_ sender: UIButton) {
        if let content = currentContent {
            delegate?.addPlayListAction(sender, content: content)
        }
    }
}

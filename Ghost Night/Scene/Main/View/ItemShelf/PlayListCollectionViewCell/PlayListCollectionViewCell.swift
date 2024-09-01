//
//  PlayListCollectionViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/8/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Data

final class PlayListCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlayListCollectionViewCell"
    @IBOutlet fileprivate weak var bgView: UIView!
    @IBOutlet fileprivate weak var thumbnail: UIImageView!
    @IBOutlet fileprivate weak var playListCountView: UIView!
    @IBOutlet fileprivate weak var iconPlayImageView: UIImageView!
    @IBOutlet fileprivate weak var countLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func rander(content: ContentPlayListItem?) {
        if let thumbnailURL = content?.thumbnailURL {
            thumbnail.sd_setImage(with: thumbnailURL, placeholderImage: UIImage(named: "ic_logo"))
        }
        
        nameLabel.text = content?.name ?? "ไม่มีชื่อ"
        if let playListCount = content?.contentCount {
            countLabel.text = "\(playListCount)"
        } else {
            countLabel.text = ""
        }
    }
    
    // MARK :- setup
    private func setUp() {
        nameLabel.textColor = .white
        bgView.cornerRadius(cornerRadius: 10.0)
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0)
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 1.0 //Here your control your blur
    }

}

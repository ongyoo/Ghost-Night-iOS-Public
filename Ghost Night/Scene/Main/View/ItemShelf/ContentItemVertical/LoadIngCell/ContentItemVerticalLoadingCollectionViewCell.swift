//
//  ContentItemVerticalLoadingCollectionViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Data

final class ContentItemVerticalLoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentItemVerticalLoadingCollectionViewCell"
    @IBOutlet private weak var bgView: FAView!
    @IBOutlet private weak var thubnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        bgView.cornerRadius(cornerRadius: 10.0)
        self.cornerRadius(cornerRadius: 10.0)
        self.dropShadow(color: UIColor.black,
                        opacity: 0.4, offSet: CGSize(width: 0, height: 4),
                        radius: 3,
                        scale: true)
        thubnailImageView.cornerRadius(cornerRadius: 10.0)
    }

}

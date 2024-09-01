//
//  PlayListItemTableViewCell.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-06-07.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit

final class PlayListItemTableViewCell: UITableViewCell {
    static let identifier = "PlayListItemTableViewCell"
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK : Action
    @IBAction private func moreAction(_ sender: UIButton) {
        debugPrint("Edit Action PlayListItemTableViewCell")
    }
}

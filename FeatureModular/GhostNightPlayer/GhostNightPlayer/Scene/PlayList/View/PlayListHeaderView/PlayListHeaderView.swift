//
//  PlayListHeaderView.swift
//  GhostNightPlayer
//
//  Created by Komsit Developer on 2020-06-07.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Core

public protocol PlayListHeaderDelegate: class {
    func playAction(_ sender: UIButton)
}

final class PlayListHeaderView: UIView {
    @IBOutlet private weak var listTitleLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    public weak var delegate: PlayListHeaderDelegate?
    
    // MARK: - View Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setTitle(text: String) {
        listTitleLabel.text = text
    }

    public static func loadNib() -> PlayListHeaderView {
        guard let view = AppStoryboard.AudioPlayer.bundleId.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? Self else {
            fatalError("The nib expected its root view to be of type \(self)")
        }
        return view
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        self.delegate?.playAction(sender)
    }
}

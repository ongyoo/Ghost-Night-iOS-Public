//
//  MainHeaderView.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import MarqueeLabel
import Reusable
import SDWebImage
import Core

public protocol MainHeaderDelegate {
    func didTapAvatar()
}

final public class MainHeaderView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var avatarBackgroundView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var announceView: UIView!
    @IBOutlet private weak var announceTitleLabel: UILabel!
    @IBOutlet private weak var announceTitleView: UIView!
    @IBOutlet private weak var announceValueLabel: MarqueeLabel!
    
    private let avatarDefault = "ic_avatar_default"
    
    public var delegate: MainHeaderDelegate?
    
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    // MARK: - View Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    
    // MARK :- Public
    public func reload() {
        setView()
    }
    
    public func setAvatarImage(image: UIImage?) {
        guard let image = image else {
            avatarImageView.image = UIImage.imageNamedWithBundle(avatarDefault, AppStoryboard.Component.bundleId)
            return
        }
        avatarImageView.image = image
    }
    
    public func setAvatarDefault() {
        avatarImageView.image =  UIImage.imageNamedWithBundle(avatarDefault, AppStoryboard.Component.bundleId)
    }
    
    public func setAvatarImage(url: URL?) {
        guard let url = url else {
            avatarImageView.image =  UIImage.imageNamedWithBundle(avatarDefault, AppStoryboard.Component.bundleId)
            return
        }
        avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: avatarDefault))
    }
    
    public func setAvatarShow() {
        avatarBackgroundView.isHidden = false
    }
    
    public func setAvatarHiden() {
        avatarBackgroundView.isHidden = true
    }
    
    public func setTitle(string: String?) {
        guard let string = string else { return }
        titleLabel.text = string
    }
    
    public func setAnnounceValue(text: String?) {
        guard let text = text else {
            announceValueLabel.text = "ประกาศ"
            return
        }
        announceValueLabel.text = text
    }
    
    // MARK :- Private Setup
    private func setView() {
        avatarImageView.image =  UIImage.imageNamedWithBundle(avatarDefault, AppStoryboard.Component.bundleId)
        backgroundImageView.image = UIImage.imageNamedWithBundle("bg_main_header", AppStoryboard.Component.bundleId)
        announceValueLabel.textColor = .black
        titleLabel.text = ""
        announceTitleLabel.text = "ประกาศ"
        announceValueLabel.text = "คืนนี้มีจัดรายการ live สดเริ่มรายการ 20:30 น. สนใจเล่าสดติดต่อ 081-999999"
        announceTitleView.cornerRadius(cornerRadius: 6.0)
        avatarBackgroundView.circle()
        avatarImageView.circle()
        avatarBackgroundView.dropShadow(color: UIColor(red: 126.0 / 255.0,
                                                       green: 211.0 / 255.0,
                                                       blue: 33.0 / 255.0,
                                                       alpha: 0.51),
                                        opacity: 0.4, offSet: CGSize(width: 0, height: 4),
                                        radius: 3,
                                        scale: true)
        announceView.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
    }
    
    @IBAction func avatarAction(_ sender: UIButton) {
        delegate?.didTapAvatar()
    }
}

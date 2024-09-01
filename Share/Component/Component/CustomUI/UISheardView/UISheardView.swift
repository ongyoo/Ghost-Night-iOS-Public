//
//  UISheardView.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 1/19/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Reusable
import Data

protocol UISheardViewDelegate {
    func sheardAction(_ sender: UIButton)
    func addPlayListAction(_ sender: UIButton)
}

class UISheardView: UIView, NibOwnerLoadable {
    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var sheardButton: UIButton!
    @IBOutlet fileprivate weak var addPlayListButton: UIButton!
    
    // Delegate
    var delegate: UISheardViewDelegate?
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    // MARK :- Private
    private func setView() {
        let borderColor = UIColor(red: 155.0/255.0,
                            green: 155.0/255.0,
                            blue: 155.0/255.0,
                            alpha: 1.0)
        sheardButton.layer.borderWidth = 1.0
        sheardButton.layer.borderColor = borderColor.cgColor
        sheardButton.cornerRadius(cornerRadius: 12.0)
        
        addPlayListButton.layer.borderWidth = 1.0
        addPlayListButton.layer.borderColor = borderColor.cgColor
        addPlayListButton.cornerRadius(cornerRadius: 12.0)
        
        addPlayListButton.isHidden = true
    }
    
    // MARK :- Action
    @IBAction private func sheardAction(_ sender: UIButton) {
        delegate?.sheardAction(sender)
    }
    
    @IBAction private func addPlayListAction(_ sender: UIButton) {
        delegate?.addPlayListAction(sender)
    }
}

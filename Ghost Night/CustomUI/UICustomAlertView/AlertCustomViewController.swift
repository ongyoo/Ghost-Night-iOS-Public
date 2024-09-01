//
//  AlertCustomViewController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit

final class AlertCustomViewController: UIViewController {
    enum AlertType {
        case major
        case all
    }
    
    enum ButtonType {
        case primary
        case secondary
        case success
        case danger
        case warning
        case info
        case light
        case dark
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                //0, 123, 255
                return UIColor(red: 0/255.0, green: 123.0/255.0, blue: 255.0/255.0, alpha: 0.8)
            case .secondary:
                //108, 117, 125
                return UIColor(red: 108.0/255.0, green: 117.0/255.0, blue: 125.0/255.0, alpha: 0.8)
            case .success:
                //40, 167, 69
                return UIColor(red: 40.0/255.0, green: 167.0/255.0, blue: 69.0/255.0, alpha: 0.8)
            case .danger:
                //220, 53, 69
                return UIColor(red: 220.0/255.0, green: 53.0/255.0, blue: 69.0/255.0, alpha: 0.8)
            case .warning:
                //255, 193, 7
                return UIColor(red: 255.0/255.0, green: 193.0/255.0, blue: 7.0/255.0, alpha: 0.8)
            case .info:
                //23, 162, 184
                return UIColor(red: 23.0/255.0, green: 162.0/255.0, blue: 184.0/255.0, alpha: 0.8)
            case .light:
                //248, 249, 250
                return UIColor(red: 248.0/255.0, green: 249.0/255.0, blue: 250.0/255.0, alpha: 0.8)
            case .dark:
                //52, 58, 64
                return UIColor(red: 52.0/255.0, green: 58.0/255.0, blue: 64.0/255.0, alpha: 0.8)
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .primary, .secondary, .success, .danger, .info, .dark:
                return UIColor.white
            case .warning, .light:
                //255, 193, 7
                return UIColor.black
            }
        }
    }
    
    @IBOutlet fileprivate weak var bgView: UIView!
    @IBOutlet fileprivate weak var alertBoxView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var lineView: UIView!
    @IBOutlet fileprivate weak var majorButton: UIButton!
    @IBOutlet fileprivate weak var minorButton: UIButton!
    
    private var titleString: String?
    var messageString: String?
    private var majorTitleString: String?
    private var minorTitleString: String?
    
    private var majorButtonType: ButtonType = .light
    private var minorButtonType: ButtonType = .light
    private var alertType: AlertType = .all
    
    typealias CustomAlertActionHandler = (() -> Void)
    // CallBack
    var minorHandler: CustomAlertActionHandler?
    var majorHandler: CustomAlertActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setRoundCorner()
    }
    
    // MARK :- Public
    func set(title: String? = "", message: String? = "", majorTitleButton: String, majorButtonType: ButtonType? = .light, minorTitleButton: String, minorButtonType: ButtonType? = .light) {
        self.titleString = title
        self.messageString = message
        self.majorTitleString = majorTitleButton
        self.majorButtonType = majorButtonType ?? .light
        self.minorTitleString = minorTitleButton
        self.minorButtonType = minorButtonType ?? .light
        self.alertType = .all
    }
    
    func set(title: String? = "", message: String? = "", majorTitleButton: String, majorButtonType: ButtonType? = .light) {
        self.titleString = title
        self.messageString = message
        self.majorTitleString = majorTitleButton
        self.majorButtonType = majorButtonType ?? .light
        self.alertType = .major
    }
    
    
    // MARK :- Setup
    private func setup() {
        alertBoxView.cornerRadius(cornerRadius: 10.0)
        //majorButton.cornerRadius(cornerRadius: 8.0)
        //minorButton.cornerRadius(cornerRadius: 8.0)
        
        titleLabel.text = self.titleString
        messageLabel.text = self.messageString
        
        majorButton.setTitle(self.majorTitleString , for: .normal)
        majorButton.tintColor = majorButtonType.fontColor
        minorButton.setTitleColor(majorButtonType.fontColor, for: .normal)
        majorButton.backgroundColor = majorButtonType.backgroundColor
        
        minorButton.setTitle(self.minorTitleString , for: .normal)
        minorButton.tintColor = minorButtonType.fontColor
        minorButton.setTitleColor(minorButtonType.fontColor, for: .normal)
        minorButton.backgroundColor = minorButtonType.backgroundColor
        
        if alertType == .major {
            minorButton.isHidden = true
            lineView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5) {
            self.bgView.backgroundColor = UIColor(red: 170.0/255.0,
                                                  green: 170.0/255.0,
                                                  blue: 170.0/255.0,
                                                  alpha: 0.4)
        }
    }
    
    private func setRoundCorner() {
        if alertType == .major {
            majorButton.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
        } else {
            majorButton.roundCorners(corners: [.bottomLeft], radius: 10.0)
            minorButton.roundCorners(corners: [.bottomRight], radius: 10.0)
        }
    }
    
    // MARK :- Action
    @IBAction private func majorAction(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.majorHandler?()
        }
    }
    
    @IBAction private func minorAction(_ sender: UIButton) {
        self.dismiss(animated: true) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.minorHandler?()
        }
    }
}


// MARK : - Static Method
extension AlertCustomViewController {
    // MARK : - Static Method
    static func instantiateViewController() -> AlertCustomViewController {
        if let vc = AlertCustomViewController.instantiateFromAppStoryboard(appStoryboard: .AlertCustom) {
            return vc
        }
        return AlertCustomViewController()
    }
    
    // MARK - showDialog
    func show(target: UIViewController? = nil) {
        if let rootVC = target ?? UIApplication.getTopViewController() {
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            rootVC.present(self, animated: true, completion: nil)
        }
    }
}


//
//  UIViewContoller.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 4/24/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
import FTIndicator

public extension UIViewController {
    func showAlert(title: String?, message: String?, titleButton: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: titleButton, style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, titleButton: String?, callback: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: titleButton, style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            callback()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showAlert(title: String?, message: String?, majorButton: String?, minorButton: String?, majorCallback: @escaping (() -> Void), minorCallback: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let majorAction = UIAlertAction(title: majorButton, style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
            majorCallback()
        }
        
        let minorAction = UIAlertAction(title: minorButton, style: .destructive) { (_) in
            alert.dismiss(animated: true, completion: nil)
            minorCallback()
        }
        
        alert.addAction(majorAction)
        alert.addAction(minorAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}




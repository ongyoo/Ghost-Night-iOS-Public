//
//  AlertHelper.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/22/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import UIKit
import FacebookShare

public class AlertHelper {
    public class func showAlert(with title: String?, message: String?, callBackOk: ((UIAlertAction) -> Void)?, callBackCancel: ((UIAlertAction) -> Void)?, viewController: UIViewController) {
        
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "AlertOK".localized, style: .default, handler: callBackOk)
        alertControl.addAction(okAction)
        viewController.present(alertControl, animated: true)
    }
    
    public class func alert(title: String, message: String, majorTitleButton: String, majorButtonType: AlertCustomViewController.ButtonType? = .light, minorTitleButton: String, minorButtonType: AlertCustomViewController.ButtonType? = .light, majorAction: (() -> Void)?, minorAction: (() -> Void)?) {
        if let topView = UIApplication.getTopViewController()?.presentedViewController,
            topView.isKind(of: AlertCustomViewController.self),
            let vc = topView as? AlertCustomViewController,
            vc.messageString == message { return }
        
        let alert = AlertCustomViewController.instantiateViewController()
        alert.set(title: title, message: message, majorTitleButton: majorTitleButton, majorButtonType: majorButtonType, minorTitleButton: minorTitleButton, minorButtonType: minorButtonType)
        alert.majorHandler = majorAction
        alert.minorHandler = minorAction
        DispatchQueue.main.async { alert.show() }
    }
    
    public class func alert(title: String, message: String, majorTitleButton: String, majorButtonType: AlertCustomViewController.ButtonType? = .light, majorAction: (() -> Void)?) {
        if let topView = UIApplication.getTopViewController()?.presentedViewController,
        topView.isKind(of: AlertCustomViewController.self),
        let vc = topView as? AlertCustomViewController,
        vc.messageString == message { return }
        
        let alert = AlertCustomViewController.instantiateViewController()
        alert.set(title: title, message: message, majorTitleButton: majorTitleButton, majorButtonType: majorButtonType)
        alert.majorHandler = majorAction
        DispatchQueue.main.async { alert.show() }
    }
}

// MARK :- ShareDialogViewController
public final class ShareDialogViewController: UIViewController {
    public func showShareDialog<C: SharingContent>(_ target: UIViewController, content: C, mode: ShareDialog.Mode = .automatic) {
        let dialog = ShareDialog(fromViewController: target, content: content, delegate: self)
        dialog.mode = mode
        dialog.show()
        
        //ShareDialog(fromViewController: self, content: shareContent, delegate: sel
    }
}
// MARK :- SharingDelegate
extension ShareDialogViewController: SharingDelegate {
    public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        let title = "Share Success"
        let message = "Succesfully shared: \(results)"
        AlertHelper.alert(title: title, message: message, majorTitleButton: "AlertOK".localized) {}
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        let title = "Share Failed"
        let message = "Sharing failed with error \(error)"
        AlertHelper.alert(title: title, message: message, majorTitleButton: "AlertOK".localized) {}
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
        let title = "Share Cancelled"
        let message = "Sharing was cancelled by user."
        AlertHelper.alert(title: title, message: message, majorTitleButton: "AlertOK".localized) {}
    }
}

public struct ShareModel {
    public var hashtag: String? = ""
    public var pageID: String? = "113227676884200"
    public var contentURL: URL? = URL(string: "https://www.facebook.com/113227676884200")!
    public var quote: String? = ""
    
    public init(hashtag: String? = nil, pageID: String? = nil, contentURL: URL? = nil, quote: String? = nil) {
        self.hashtag = hashtag
        self.pageID = pageID
        self.contentURL = contentURL
        self.quote = quote
    }
    
    public func convertToShareLinkContent() -> ShareLinkContent {
        let shareContent = ShareLinkContent()
        shareContent.hashtag = .init(self.hashtag ?? "#GhostNight")
        shareContent.pageID = self.pageID
        
        if let contentURL = self.contentURL {
             shareContent.contentURL = contentURL
        }

        shareContent.quote = self.quote
        return shareContent
    }

}

//
//  UIView.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 5/17/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import UIKit

public extension UIView {
    
    func takeSnapshotOfView() -> UIImage? {
        let capturedSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        
        UIGraphicsBeginImageContextWithOptions(capturedSize, false, 0.0)
        self.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: capturedSize), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func circle() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func cornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
}


//
//  UIImage.swift
//  SCCARE
//
//  Created by Komsit Chusangthong on 5/14/18.
//  Copyright © 2018 Komsit Chusangthong. All rights reserved.
//

import UIKit

public extension UIImage {
    
    var pngRepresentationData: Data? {
        return self.pngData()
    }
    
    var jpegRepresentationData: Data? {
        return resizeImage(image: self).jpegData(compressionQuality: 0.6)
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let maxWidth: CGFloat = 1600
        let maxHeight: CGFloat = 1200
        let size = image.size
        
        let widthRatio  = maxWidth  / image.size.width
        let heightRatio = maxHeight / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

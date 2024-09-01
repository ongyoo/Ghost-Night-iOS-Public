//
//  CustomSlider.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 12/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit

public class CustomSlider: UISlider {
    @IBInspectable public var trackWidth: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}

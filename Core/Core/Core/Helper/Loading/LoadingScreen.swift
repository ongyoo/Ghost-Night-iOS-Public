//
//  LoadingScreen.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/21/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import Foundation
import SnapKit

public final class LoadingScreen : UIView {
    
    let overlayLoading = UIView()
    var loadingImageView = UIImageView()
    
    private(set) var isAnimating: Bool = false
    
    var animateDuration:Double = 0.35
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setImage() {
        var imageObj: [UIImage] = []
        for index in 0...13 {
            imageObj.append(UIImage(named: "ic_loading_\(index)")!)
        }
        loadingImageView.animationDuration = 1.5
        loadingImageView.animationImages = imageObj
    }
    
    internal func setup() {
        // No clear background
        self.backgroundColor = UIColor.clear
        
        // Controllable overlay loading
        self.overlayLoading.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 236/255, alpha: 0.5)
        self.overlayLoading.alpha = 0
        self.addSubview(overlayLoading)
        self.overlayLoading.snp.makeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        let loaderSize = CGFloat(80)
        
        // add circle in background loader
        let sizeBg = loaderSize * 1.5
        let backgroundLoaderView = UIView()
        backgroundLoaderView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        backgroundLoaderView.layer.cornerRadius = sizeBg * 0.5
        self.addSubview(backgroundLoaderView)
        backgroundLoaderView.snp.makeConstraints { (make) in
            make.size.equalTo(sizeBg)
            make.center.equalTo(self)
        }
        
        self.loadingImageView.alpha = 1.0
        self.addSubview(loadingImageView)
        self.loadingImageView.snp.makeConstraints { (make) in
            make.size.equalTo(loaderSize)
            make.center.equalTo(self)
        }
    }
    
    public func attach(hostView:UIView) {
        // Attach if necessary
        if !hostView.subviews.contains(self) {
            self.overlayLoading.alpha = 0
            hostView.addSubview(self)
            
            self.snp.remakeConstraints({ (make) in
                make.size.equalTo(hostView)
                make.center.equalTo(hostView)
            })
            self.setNeedsUpdateConstraints()
            hostView.updateConstraints()
        }
        self.isHidden = false
        self.startAnimating()
    }
    
    public func detachAndStop() {
        self.stopAnimating {
            self.removeFromSuperview()
        }
    }
    
    public func hideAndStop() {
        self.stopAnimating {
            self.isHidden = true
        }
    }
    
    private func startAnimating() {
        if self.isAnimating {
            return
        }
        self.isAnimating = true
        loadingImageView.startAnimating()
    }
    
    private func stopAnimating(done: @escaping () -> Void) {
        UIView.animate(withDuration: animateDuration, animations: {
            self.overlayLoading.alpha = 0
            self.loadingImageView.alpha = 0
        }, completion: { (finished) in
            self.isAnimating = false
            self.loadingImageView.startAnimating()
            done()
        })
    }
}


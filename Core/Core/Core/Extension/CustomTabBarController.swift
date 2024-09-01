//
//  CustomTabBarController.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/4/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit

open class CustomTabBarController: UITabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.tabBar.barTintColor = .white
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SupportedFont.bold.of(size: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SupportedFont.bold.of(size: 10)], for: .selected)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUp()
    }
    
    open func setUp() {
        let icons = ["ic_tab_playlist", "ic_tab_feed", "ic_tab_about"]
        let titles = ["เพลย์ลิสต์", "ฟิตหลอน", "เกี่ยวกับเรา"]
                if let count = self.tabBar.items?.count {
                    for i in 0...(count-1) {
                        let icon   = icons[i]
                        let title = titles[i]
        
                        self.tabBar.items?[i].title = title
                        self.tabBar.items?[i].image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                        //self.tabBar.items?[i].imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                    }
                }
    }
}

//
//  PlayListHorizontalShelfCollectionViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/9/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit

final class PlayListHorizontalShelfCollectionViewCell: UITableViewCell {
    static let identifier = "HorizontalShelfTableViewCell"
    @IBOutlet fileprivate weak var headferShelfView: UIHeaderShelfView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var bgView: UIView!
    
    private var indexOfCellBeforeDragging = 0
    
    // MARK :- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setCollectionView()
        registerCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func render(indexPath: IndexPath) {
        if indexPath.row > 0 {
            
        }
    }
    
    // MARK :- setup
    private func setUp() {
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 16.0)
        headferShelfView.setTitleLabel(string: "เพลย์ลิสต์ของฉัน")
        headferShelfView.setSeeMoreType(type: .addPlayList)
        pageControl.numberOfPages = 10
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCell() {
        collectionView.register(UINib(nibName: PlayListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayListCollectionViewCell.identifier)
    }
}

// MARK :- Public
extension PlayListHorizontalShelfCollectionViewCell {
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
}

extension PlayListHorizontalShelfCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.identifier, for: indexPath) as? PlayListCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK :- Flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
}

extension PlayListHorizontalShelfCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}


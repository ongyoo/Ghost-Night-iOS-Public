//
//  HorizontalSecondShelfTableViewCell.swift
//  Ghost Night
//
//  Created by Komsit Chusangthong on 11/9/19.
//  Copyright © 2019 Komsit Chusangthong. All rights reserved.
//

import UIKit
import Data

final class HorizontalSecondShelfTableViewCell: UITableViewCell {
    static let identifier = "HorizontalSecondShelfTableViewCell"
    @IBOutlet fileprivate weak var headferShelfView: UIHeaderShelfView!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var bgView: UIView!
    
    private var indexOfCellBeforeDragging = 0
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        return collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    // Delegate
    weak var delegate: HorizontalFirstShelfDelegate?
    // Store
    fileprivate var currentContent: ContentModel? {
        didSet {
            getContent()
        }
    }
    
    // MARK :- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        setCollectionView()
        configureCollectionViewLayoutItemSize()
        registerCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCollectionViewLayoutItemSize()
    }
    
    // MARK :- setup
    private func setUp() {
        bgView.cornerRadius(cornerRadius: 16.05)
        headferShelfView.setTitleLabel(string: "test")
        headferShelfView.setSeeMoreType(type: .hide)
        pageControl.numberOfPages = currentContent?.contentList?.count ?? 0
    }
    
    private func getContent() {
        if let item = currentContent, let cmsId = item.shelfItem?.cmsId, !item.isContentListLoaded && !item.isLoading {
            delegate?.requestContent(cmsId: cmsId, type: item.shelfItem?.slugType ?? ShelfSlug.unknown)
        } else {
            collectionView.reloadData()
        }
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCell() {
        collectionView.register(UINib(nibName: PlayListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayListCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: ContentItemVerticalCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ContentItemVerticalCollectionViewCell.identifier)
        
        // MARK :- Loading Cell
        collectionView.register(UINib(nibName: ContentItemVerticalLoadingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ContentItemVerticalLoadingCollectionViewCell.identifier)
    }
    
    private func configureCollectionViewLayoutItemSize() {
        switch currentContent?.shelfItem?.slugType {
        case .recommend?, .radio?:
            configureContentIteCollectionViewLayoutItemSize()
        default:
            configurePlayListCollectionViewLayoutItemSize()
        }
    }
    
    private func configurePlayListCollectionViewLayoutItemSize() {
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewFlowLayout.collectionView!.frame.size.width,
                                                   height: collectionViewFlowLayout.collectionView!.frame.size.height)
    }
    
    private func configureContentIteCollectionViewLayoutItemSize() {
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewFlowLayout.itemSize = CGSize(width: 138.0,
                                                   height: collectionViewFlowLayout.collectionView!.frame.size.height - 10)
    }
}

// MARK :- Public
extension HorizontalSecondShelfTableViewCell {
    func setHeader(item: ContentModel?) {
        if let title = item?.shelfItem?.nameTh {
            headferShelfView.setTitleLabel(string: title)
        }
        
        if let iconURL = item?.shelfItem?.iconUrl {
            headferShelfView.setIcon(image: nil, url: iconURL)
        }
        currentContent = item
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
}

extension HorizontalSecondShelfTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let type = currentContent?.shelfItem?.slugType {
            switch type {
            case .myPlayList:
                return currentContent?.myPlayList?.count ?? 1
            default:
                return currentContent?.contentList?.count ?? 5
            }
        }
        return currentContent?.contentList?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let type = currentContent?.shelfItem?.slugType {
            switch type {
            case .myPlayList:
                if let item = currentContent?.myPlayList?[safe: indexPath.row],
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCollectionViewCell.identifier, for: indexPath) as? PlayListCollectionViewCell  {
                    cell.rander(content: item)
                    return cell
                }
                
            default:
                if let item = currentContent?.contentList?[safe: indexPath.row] {
                    switch item.contentType {
                    case .content?, .audio?, .live?:
                        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemVerticalCollectionViewCell.identifier, for: indexPath) as? ContentItemVerticalCollectionViewCell {
                            cell.rander(content: item)
                            return cell
                        }
                    default: break
                    }
                }
            }
        }
        
        return loadingContent(collectionView, cellForItemAt: indexPath)
    }
    
    private func loadingContent(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemVerticalLoadingCollectionViewCell.identifier, for: indexPath) as? ContentItemVerticalLoadingCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let type = currentContent?.shelfItem?.slugType else { return }
        switch type {
        case .myPlayList:
            if let item = currentContent?.myPlayList?[safe: indexPath.row] {
                delegate?.didSelectContentPlayList(content: item)
            }
        default:
            if let item = currentContent?.contentList?[indexPath.row] {
                delegate?.didSelect(content: item)
            }
        }
    }
}

extension HorizontalSecondShelfTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}


//
//  ImageDataSource.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class ImageDataSource: NSObject, UICollectionViewDataSource {
    
    var isFetchingPhotos = false

    var photographersInstance = PhotographersInstance.shared

    @IBOutlet var loadingView: UIView?
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var changeButton: UIBarButtonItem!

    override init() {
        super.init()
        fetchNextPage()
    }

    func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView?.performBatchUpdates({
                for index in 0...self.photographersInstance.photos.count - 1 {
                    self.collectionView?.deleteSections(IndexSet(integer: index))
                }
                self.photographersInstance.photos.removeAll()
                self.collectionView?.reloadData()
            }, completion: { _ in
                self.fetchNextPage()
            })
        }
    }

    @IBAction func changePhotographer() {
        if let collectionView = collectionView {
            collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        }
        photographersInstance.presenter?()
        photographersInstance.updater = { [weak self] in
            self?.updateCollectionView()
        }
    }
    
    func photo(forIndexPath indexPath: IndexPath) -> Photo {
        if indexPath.section == photographersInstance.photos.count - 1 { fetchNextPage() }
        return self.photographersInstance.photos[indexPath.section][indexPath.item]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photographersInstance.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photographersInstance.photos[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell

        let photo = self.photo(forIndexPath: indexPath)
        cell.photo = photo

        return cell
    }
    
    func loadingCenter() -> CGPoint {
        let y: CGFloat
        if (photographersInstance.photos.count > 0) {
            y = (self.collectionView?.bounds.maxY ?? 0) - 60
        } else {
            y = (self.collectionView?.bounds.midY ?? 0)
        }

        return CGPoint(
            x: (self.collectionView?.bounds.midX ?? 0),
            y: y
        )
    }
    
    private func fetchNextPage() {
        if isFetchingPhotos { return }
        isFetchingPhotos = true
        
        if let loadingView = loadingView, let collectionView = collectionView?.superview {
            collectionView.addSubview(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter()
        }
        
        let currentPage = photographersInstance.photos.count
        FlickrFetcher().getPhotosUrls(for: photographersInstance.currentPhotographer, forPage: currentPage+1) { [weak self] in
            if $0.count > 0 {
                self?.photographersInstance.photos.append($0)
                self?.collectionView?.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        
            self?.loadingView?.removeFromSuperview()
        }
    }
}

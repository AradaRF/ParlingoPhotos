//
//  ImageDataSource.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu


private let reuseIdentifier = "PhotoCell"

class ImageDataSource: NSObject, UICollectionViewDataSource{
  
    
    var id = Photographers.alfredoliverani
    var photos: [[Photo]] = []
    var comments: [PhotoComment] = []
    var isFetchingPhotos = false
    @IBOutlet weak var view: PhotoCollectionViewController!
    
    @IBOutlet weak var navigationIt: UINavigationController!
    
    @IBOutlet var loadingView: UIView?
    //work with this
    @IBOutlet weak var collectionView: UICollectionView?

    override init() {
        super.init()
        
        self.fetchNextPage()
    }
    
    func fetchNextPage() {
        if isFetchingPhotos { return }
        isFetchingPhotos = true
        
        if let loadingView = loadingView, let collectionView = collectionView?.superview {
            collectionView.addSubview(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter()
        }
        
        let currentPage = photos.count
        FlickrFetcher().getPhotosUrls(id: id.rawValue, forPage: currentPage+1) { [weak self] in
            if $0.count > 0 {
                self?.photos.append($0)
                self?.collectionView?.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        
            self?.loadingView?.removeFromSuperview()
        }
    }
    
    func fetchPhotos(for photographer: String) {
       
        photos.removeAll()
        let currentPage = photos.count
        FlickrFetcher().getPhotosUrls(id: photographer, forPage: currentPage+1) { [weak self] in
            if $0.count > 0 {
                self?.photos.append($0)
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        
            
        }
    }
    
    func fetchComments(for photo: Photo){
        comments.removeAll()
        FlickrFetcher().getPhotoComments(for: photo){ [weak self] in
            if $0.count > 0 {
                self?.comments.append(contentsOf: $0)
            }
        }
    }
   
    func photo(forIndexPath indexPath: IndexPath) -> Photo {
        if indexPath.section == photos.count - 1 { fetchNextPage() }
        return self.photos[indexPath.section][indexPath.item]
    }
    
    func loadingCenter() -> CGPoint {
        let y: CGFloat
        if (photos.count > 0) {
            y = (self.collectionView?.bounds.maxY ?? 0) - 60
        } else {
            y = (self.collectionView?.bounds.midY ?? 0)
        }

        return CGPoint(
            x: (self.collectionView?.bounds.midX ?? 0),
            y: y
        )
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos[section].count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell

        let photo = self.photo(forIndexPath: indexPath)
        fetchComments(for: photo)
        cell.photo = photo

        return cell
    }
}

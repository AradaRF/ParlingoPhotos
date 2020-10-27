//
//  PhotoCollectionViewController.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu



class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NavigationProtocol{
    

    @IBOutlet weak var item: UIBarButtonItem!
    @IBOutlet var datasource: ImageDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNavItemMenu()
    }
    
    func setNavItemMenu(){
       
        createMenu().didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            let ph = Photographers.alfredoliverani.array[indexPath]
            DispatchQueue.main.async {
                self?.getPhotos(photographer: ph)
            }
        }
    }
    
    func createMenu() -> BTNavigationDropdownMenu{
        let menuView = self.navigationItem.createMenu(title: "Select Photographer", data: Photographers.alfredoliverani.array)
        
        return menuView
    }
     
    func getPhotos(photographer: String){
        for ph in Photographers.allCases{
            if ph.displayName == photographer{
                datasource.fetchPhotos(for: ph.rawValue)
                item.loadImageFromUrl(ph.imageURL)
            }
        }
    }
 
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsvc") as? DetailsViewController else { return }
        
        DispatchQueue.main.async{
            photoVC.photo = self.datasource.photo(forIndexPath: indexPath)
            photoVC.comments = self.datasource.comments
            let navVC = self.initialiseNavController(rootVC: photoVC)
            self.presentNewView(navController: navVC)
        }
     }
}


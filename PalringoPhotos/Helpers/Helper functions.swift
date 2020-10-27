//
//  Helper extensions.swift
//  PalringoPhotos
//
//  Created by Ricardo Ferreira on 27/10/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit
import BTNavigationDropdownMenu

extension UIImage {

    func resizeImage(targetSize: CGSize) -> UIImage {
        
        let imageSize = self.size
        let newWidth  = targetSize.width  / self.size.width
        let newHeight = targetSize.height / self.size.height
        var newSize: CGSize
        var newImage = UIImage()
                
        if(newWidth > newHeight) {
            newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
        } else {
            newSize = CGSize(width: imageSize.width * newWidth,  height: imageSize.height * newWidth)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        self.draw(in: rect)
        
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            newImage = img
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension UICollectionViewController{
    
    func presentNewView(navController: UINavigationController) {
        DispatchQueue.main.async {
            self.present(navController, animated: true, completion: nil)
        }
    }
}

extension UIBarButtonItem: ImageDownloader {
   
    
    func loadImageFromUrl(_ urlString: URL) {
        downloadImage(imageUrl: urlString) { image in
            guard let img = image else { return }
                let newImg = img.resizeImage(targetSize: CGSize(width: 40, height: 40))
            self.setBackgroundImage(newImg, for: .normal, barMetrics: .default)
         
        
        }
    }
}

extension UIImageView: ImageDownloader{
    
    func loadImageFromUrl(_ urlString: URL) {
        
        downloadImage(imageUrl: urlString) { image in
            guard let img = image else { return }
            DispatchQueue.main.async {
                self.image = img
            }
        }
    }
}

extension UINavigationItem{
    
    func createMenu(title: String, data: [String]) -> BTNavigationDropdownMenu{
        let menuView = BTNavigationDropdownMenu(title: title, items:data)
        self.titleView = menuView
        
        return menuView
    }
}



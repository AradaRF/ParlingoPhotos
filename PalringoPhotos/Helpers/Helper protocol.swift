//
//  File.swift
//  PalringoPhotos
//
//  Created by Ricardo Ferreira on 27/10/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCompletion = (UIImage?) -> Void
fileprivate let imageCache = NSCache<AnyObject, UIImage>()

protocol ImageDownloader {
   
    func downloadImage(imageUrl: URL, completion: @escaping ImageCompletion)
   
}
protocol NavigationProtocol{
    func initialiseNavController(rootVC: UIViewController) -> UINavigationController
}

extension ImageDownloader {
    
    func downloadImage(imageUrl: URL, completion: @escaping ImageCompletion) {
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: imageUrl as AnyObject) {
            completion(cachedImage)
        }
        //otherwise fire off a new download
       
            URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(UIImage(named: "Error"))
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: imageUrl as AnyObject)
                        completion(downloadedImage)
                    }
                })
            }).resume()
        
    }
}

extension NavigationProtocol {
    
    func initialiseNavController(rootVC: UIViewController) -> UINavigationController  {
        let navController = UINavigationController(rootViewController: rootVC)
        return navController
    }
}

protocol DecodeHTML{
    func decodeHTMLComment(comment: String) -> String

}

extension DecodeHTML{
    
    func decodeHTMLComment(comment: String) -> String{
        let encodedString = comment

        guard let data = encodedString.data(using: .utf8) else {
            return ""
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return ""
        }

        let decodedString = attributedString.string
        
        return decodedString
    }
}


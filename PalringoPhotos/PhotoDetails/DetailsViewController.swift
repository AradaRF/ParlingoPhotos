//
//  DetailsViewController.swift
//  PalringoPhotos
//
//  Created by Ricardo Ferreira on 27/10/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

var reusableCell = "reusableCell"

class DetailsViewController: UIViewController, DecodeHTML{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var photo: Photo?
    var comments: [PhotoComment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        DispatchQueue.main.async{
            self.loadImage()
        }
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadImage(){
        if let photoUrl = photo?.url {
            imageView.loadImageFromUrl(photoUrl)
        }
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


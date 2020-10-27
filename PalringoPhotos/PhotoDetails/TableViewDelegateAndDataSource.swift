//
//  TableViewDelegateAndDataSource.swift
//  PalringoPhotos
//
//  Created by Ricardo Ferreira on 27/10/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import Foundation
import UIKit

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return comments.count
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 100
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reusableCell, for: indexPath)
            cell.detailTextLabel?.textColor = .lightGray
            cell.textLabel?.text = decodeHTMLComment(comment: comments[indexPath.row].author)
            cell.detailTextLabel?.text = decodeHTMLComment(comment: comments[indexPath.row].comment)
            
            return cell
    }
}

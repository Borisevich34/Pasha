//
//  CustomFavouriteCell.swift
//  Pasha
//
//  Created by MacBook on 11.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class CustomFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    
    var link : String?
    
    func setOutLink(newLink : String) {
        link = newLink
    }
    
    func getOutLink() -> String? {
        return link
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


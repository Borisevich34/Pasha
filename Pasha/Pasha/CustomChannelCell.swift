//
//  CustomChannelCell.swift
//  Pasha
//
//  Created by MacBook on 07.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import Foundation

import UIKit

class CustomChannelCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
//
//  CustomButton.swift
//  Pasha
//
//  Created by MacBook on 20.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    
    var isFavorite : Bool = false {
        didSet {
            self.setImage(UIImage(named: (isFavorite ? "ButtonON" : "ButtonOFF")), for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isFavorite = false
    }
    
}

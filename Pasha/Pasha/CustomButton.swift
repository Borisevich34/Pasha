//
//  CustomButton.swift
//  Pasha
//
//  Created by MacBook on 20.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    private static let buttonOn = UIImage(named: "ButtonON")
    private static let buttonOff = UIImage(named: "ButtonOFF")
    
    var isFavorite : Bool = false {
        didSet {
            if isFavorite {
                self.setImage(CustomButton.buttonOn, forState: .Normal)
            }
            else {
                self.setImage(CustomButton.buttonOff, forState: .Normal)
            }
        }
    }
    override func awakeFromNib() {
        self.isFavorite = false
    }
    
}

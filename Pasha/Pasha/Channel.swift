//
//  Channel.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit
import Foundation

class Channel {
    
    var tittle : String
    var image : UIImage
    var items : [Item]?
    
    init () {
        tittle = ""
        image = UIImage()
    }
    
    func setItems (countOfItems : Int) {
        items = [Item](count : countOfItems, repeatedValue : Item())
        for i in 0 ..< countOfItems {
            items![i] = Item() //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
    
    func getTittle() -> String {
        return tittle
    }
    func getImage () -> UIImage {
        return image
    }
    func getItem (index : Int) -> Item {
        return items![index]
    }
    
    func setTittle(newTittle : String) {
        tittle = newTittle
    }
    func setImage (newImage : UIImage) {
        image = newImage
    }
    
}

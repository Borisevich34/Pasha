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
    
    var title : String
    var image : UIImage
    var items : [Item]?
    var countOfItems : Int
    
    init () {
        title = ""
        image = UIImage()
        countOfItems = 0
    }
    
    func setItems (countItems : Int) {
        items = [Item](count : countItems, repeatedValue : Item())
        for i in 0 ..< countItems {
            items![i] = Item() //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
        countOfItems = countItems
    }
    
    func getTitle() -> String {
        return title
    }
    func getImage () -> UIImage {
        return image
    }
    func getItem (index : Int) -> Item {
        return items![index]
    }
    func getCountOfItems () -> Int {
        return countOfItems
    }
    
    
    
    func setTitle(newTitle : String) {
        title = newTitle
    }
    func setImage (newImage : UIImage) {
        image = newImage
    }
    
}

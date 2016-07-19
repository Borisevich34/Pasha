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
    var imageLink : String
    var items : [Item]?
    var countOfItems : Int
    
    init () {
        title = ""
        imageLink = ""
        countOfItems = 0
    }
    
    func setItems (countItems : Int) {
        items = [Item](count : countItems, repeatedValue : Item())
        for i in 0 ..< countItems {
            items![i] = Item()
        }
        countOfItems = countItems
    }

    subscript(index: Int) -> Item {
        get {
            return items![index]
        }
    }
    
}

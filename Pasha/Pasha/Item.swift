//
//  Item.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import Foundation

class Item {
    
    var title : String
    var description : String
    var link : String
    var imageLink : String
    var isFromFavorites : Bool
    
    init () {
        title = ""
        description = ""
        link = ""
        isFromFavorites = false
        imageLink = ""
    }
    
}
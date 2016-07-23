//
//  Item.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

class New: CustomStringConvertible {
    
    var title = ""
    var subtitle = ""
    var link = ""
    var isFromFavorites = false
    var imageLink = ""
    
    var description: String {
        return "New: \(title) \n"
    }
}

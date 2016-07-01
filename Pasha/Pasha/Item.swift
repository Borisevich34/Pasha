//
//  Item.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import Foundation

class Item {
    
    var tittle : String
    var description : String
    var link : String
    
    init () {
        tittle = ""
        description = ""
        link = ""
    }
    
    func setTittle(string : String) {
        tittle = string
    }
    
}
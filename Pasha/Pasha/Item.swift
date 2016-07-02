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
    
    func setTitle(string : String) {
        tittle = string
    }
    func setDescription(string : String) {
        description = string
    }
    func setLink(string : String) {
        link = string
    }
    
    func getTitle() -> String {
        return tittle
    }
    func getDescription() -> String {
        return description
    }
    func getLink() -> String {
        return link
    }
    
}
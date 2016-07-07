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
    var imageLink : String
    var channel : String
    
    init () {
        tittle = ""
        description = ""
        link = ""
        channel = ""
        imageLink = ""
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
    func setImageLink(string : String) {
        imageLink = string
    }
    func setChannel(string : String) {
        channel = string
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
    func getImageLink() -> String {
        return imageLink
    }
    func getChannel() -> String {
        return channel
    }
    
}
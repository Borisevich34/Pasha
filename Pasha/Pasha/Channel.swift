//
//  Channel.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class Channel: CustomStringConvertible {
    
    var title = ""
    var imageLink = ""
    var news = [New]()

    subscript(index: Int) -> New {
        get {
            return news[index]
        }
    }
    
    var description: String {
        return "Channel: \(title) - \(imageLink) - \(news)"
    }
    
}

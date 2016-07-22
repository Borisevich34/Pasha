//
//  Channel.swift
//  Pasha
//
//  Created by MacBook on 28.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

class Channel {
    
    var title = ""
    var imageLink = ""
    var news = [New]()

    subscript(index: Int) -> New {
        get {
            return news[index]
        }
    }
    
}

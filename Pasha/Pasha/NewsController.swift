//
//  NewsController.swift
//  Pasha
//
//  Created by MacBook on 02.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire

class NewsController: UITableViewController {
    
    var channels = [Channel]()
    var indexOfChannel : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels[indexOfChannel].getCountOfItems()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("item")! as UITableViewCell
        
        cell.textLabel?.text = channels[indexOfChannel].getItem(indexPath.row).getTitle()
        cell.detailTextLabel?.text = channels[indexOfChannel].getItem(indexPath.row).getDescription()
        
        return cell
    }
    
}
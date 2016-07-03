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
        tableView.estimatedRowHeight = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels[indexOfChannel].getCountOfItems()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("item")
//        if cell is CustomCell {
//            let cell = cell as! CustomCell
//            cell.cellLabel.text = channels[indexOfChannel].getItem(indexPath.row).getTitle()
//            cell.cellSubtitle.text = channels[indexOfChannel].getItem(indexPath.row).getDescription()
//            return cell
//        } else {
//            return UITableViewCell()
//        }

//        guard let cell = self.tableView.dequeueReusableCellWithIdentifier("item") as? CustomCell else {
//            return UITableViewCell()
//        }
//        
//        cell.cellLabel.text = channels[indexOfChannel].getItem(indexPath.row).getTitle()
//        cell.cellSubtitle.text = channels[indexOfChannel].getItem(indexPath.row).getDescription()
//        return cell
        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("item") as? CustomCell {
            cell.cellLabel.text = channels[indexOfChannel].getItem(indexPath.row).getTitle()
            cell.cellSubtitle.text = channels[indexOfChannel].getItem(indexPath.row).getDescription()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let title: NSString = "djhfgsjhfgsdjhf"
//        let attr = [NSFontAttributeName : ""]
//        title.sizeWithAttributes()
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let requestUrl = NSURL(string: channels[indexOfChannel].getItem(indexPath.row).getLink()) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}
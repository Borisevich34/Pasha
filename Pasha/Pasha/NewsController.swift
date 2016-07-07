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

    var channel: Channel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channel?.getCountOfItems() ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("item") as? CustomItemCell {
            
            if let string = channel?.getItem(indexPath.row).getImageLink() {
                if let url = NSURL(string: string) {

                    cell.cellImageView!.af_setImageWithURL(url)
                   
                }
            }
            
            if let title = channel?.getItem(indexPath.row).getTitle() {
                cell.cellLabel.text = title
            } else {
                cell.cellLabel.text = ""
            }

            cell.cellSubtitle.text = channel?.getItem(indexPath.row).getDescription() ?? ""
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let requestUrl = NSURL(string: channel?.getItem(indexPath.row).getLink() ?? "") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}
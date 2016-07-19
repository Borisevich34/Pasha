//
//  FavouritesController.swift
//  Pasha
//
//  Created by MacBook on 11.07.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire

protocol AddToFavorites {
    func addToFavorites(item: Item)
}

class FavoritesController: UITableViewController, AddToFavorites, UITabBarDelegate {
    
    let story = NSUserDefaults.standardUserDefaults()
    var titles : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyTitles = story.stringArrayForKey("titles") {
            titles = storyTitles
        }
        else {
            titles = [String]()
        }
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("favorite") as? CustomFavoriteCell,
        let array = story.objectForKey(titles[indexPath.row]) as? [NSData] {
            
            cell.cellLabel.text = NSKeyedUnarchiver.unarchiveObjectWithData(array[0]) as? String ?? ""
            
            cell.cellSubtitle.text = NSKeyedUnarchiver.unarchiveObjectWithData(array[1]) as? String ?? ""
            
            cell.setOutLink(NSKeyedUnarchiver.unarchiveObjectWithData(array[2]) as? String ?? "")
            
            if let string = NSKeyedUnarchiver.unarchiveObjectWithData(array[3]) as? String {
                if let url = NSURL(string: string) {
                    
                    cell.cellImageView!.af_setImageWithURL(url)
    
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let url = (tableView.cellForRowAtIndexPath(indexPath) as? CustomFavoriteCell)?.getOutLink(), let requestUrl = NSURL(string: url) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            story.removeObjectForKey(titles.removeAtIndex(indexPath.row))
            story.setObject(titles, forKey: "titles")
            story.synchronize()
            
        }
        
        tableView.reloadData()
    }
    
    func addToFavorites(item: Item) {
        
        if !story.dictionaryRepresentation().keys.contains(item.title) {
           
            let title = NSKeyedArchiver.archivedDataWithRootObject(item.title)
            let subtitle = NSKeyedArchiver.archivedDataWithRootObject(item.description)
            let imageLink = NSKeyedArchiver.archivedDataWithRootObject(item.imageLink)
            let link = NSKeyedArchiver.archivedDataWithRootObject(item.link)
            
            let object : [NSData] = [title, subtitle, link, imageLink]
        
            story.setObject(object, forKey: item.title)
            
            titles.insert(item.title, atIndex: 0) //////////////////
            story.setObject(titles, forKey: "titles")   //////////////////
            
            story.synchronize()
            
            self.tableView?.reloadData()
            
        }
    }
    
}

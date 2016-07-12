//
//  ViewController.swift
//  Pasha
//
//  Created by MacBook on 26.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire
import AlamofireImage

class ViewController: UITableViewController {

    var channels = [Channel]()
    
    @IBOutlet weak var refreshingControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let controllers = self.tabBarController?.viewControllers {
            if let favourites = controllers[1] as? FavoritesController {

                CustomItemCell.delegate = favourites
            }
        }
        updateChannels()
        
        refreshingControl.addTarget(self, action: #selector(ViewController.updateChannels), forControlEvents: UIControlEvents.ValueChanged)
    }

    func isRequestGood(error: NSError?, data: NSData?)-> Bool {
        
        if (error != nil || data == nil ) {
            return false
        }
        else {
            
            let xml = SWXMLHash.parse(data!)
            
            self.channels = [Channel](count: xml["rss"]["channel"].all.count, repeatedValue: Channel())
            
            for i in 0 ..< xml["rss"]["channel"].all.count {
                
                if let text = xml["rss"]["channel"][i]["title"].element?.text, let imageLink = xml["rss"]["channel"][i]["image"]["url"].element?.text {
                    self.channels[i].setTitle(text)
                    self.channels[i].setImageLink(imageLink)
                }
                else {
                    return false
                }
                
                self.channels[i].setItems(xml["rss"]["channel"][i]["item"].all.count)

                
                for j in 0 ..< xml["rss"]["channel"][i]["item"].all.count {
                    
                    if let title = xml["rss"]["channel"][i]["item"][j]["title"].element?.text, let description = xml["rss"]["channel"][i]["item"][j]["description"].element?.text, let link = xml["rss"]["channel"][i]["item"][j]["link"].element?.text, let imageLink = xml["rss"]["channel"][i]["item"][j]["media:thumbnail"].element?.attributes["url"] {
                        
                        self.channels[i].getItem(j).setTitle(title)
                        self.channels[i].getItem(j).setDescription(description)
                        self.channels[i].getItem(j).setLink(link)
                        self.channels[i].getItem(j).setImageLink(imageLink)

                    }
                }
            }
        }
        
        return true
    }
    
    func updateChannels() {
        
        Alamofire.request(.GET, "http://feeds.bbci.co.uk/news/world/rss.xml", parameters: nil)
            .response { [unowned self] request, response, data, error in
                if !self.isRequestGood(error, data: data) {
                   
                    let alertController = UIAlertController(title: "Sorry", message:
                        "Check your internet connection", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default){(action) in self.updateChannels()})
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                    
                    if self.refreshingControl.refreshing {
                        self.refreshingControl.endRefreshing()
                    }
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("channel")! as? CustomChannelCell {
            
            cell.cellLabel.text = channels[indexPath.row].getTitle()
            
            if let url = NSURL(string: channels[indexPath.row].getImageLink()) {
                cell.cellImageView.af_setImageWithURL(url)
            }
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? NewsController {
            if let indexPath = tableView.indexPathForSelectedRow {                
                controller.channel = self.channels[indexPath.row]
            }
        }
        
    }

}
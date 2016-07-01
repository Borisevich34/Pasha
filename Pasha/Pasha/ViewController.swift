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

class ViewController: UITableViewController {

    var channels = [Channel]()
    
    @IBOutlet weak var refreshingControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChannels()
        
        refreshingControl.addTarget(self, action: #selector(ViewController.updateChannels), forControlEvents: UIControlEvents.ValueChanged)
    }

    func isRequestGood(error: NSError?, data: NSData?)-> Bool {
        
        if (error != nil) {
            
            return false
            
        } else {
            
            let xml = SWXMLHash.parse(data!)
            
            self.channels = [Channel](count: xml["rss"]["channel"].all.count, repeatedValue: Channel())
            
            for i in 0 ..< xml["rss"]["channel"].all.count {
                
                self.channels[i].setTittle(xml["rss"]["channel"][i]["title"].element!.text!)
                self.channels[i].setItems(xml["rss"]["channel"][i]["item"].all.count)
                
                if let url = NSURL(string: xml["rss"]["channel"][i]["image"]["url"].element!.text!) {
                    if let imageData = NSData(contentsOfURL: url) {
                        self.channels[i].setImage(UIImage(data: imageData)!)
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
                
                for j in 0 ..< xml["rss"]["channel"][i]["item"].all.count {
                    
                    self.channels[i].getItem(j).setTittle(xml["rss"]["channel"][i]["item"][j]["title"].element!.text!)
                    //+links
                    //+description
                }
            }
            
            self.tableView.reloadData()
            
            if refreshingControl.refreshing {
                refreshingControl.endRefreshing()
            }
        }
        
        return true
    }
    
    func updateChannels() {
    
        Alamofire.request(.GET, "http://feeds.bbci.co.uk/news/world/rss.xml", parameters: nil)
            .response { request, response, data, error in
                
                if self.isRequestGood(error, data: data) == false {
                   
                    let alertController = UIAlertController(title: "Sorry", message:
                        "Check you internet connection", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default){(action) in self.updateChannels()})
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("channel")! as UITableViewCell
        
        cell.textLabel?.text = channels[indexPath.row].getTittle()
        cell.imageView?.image = channels[indexPath.row].getImage()
        
        return cell
    }
    

}
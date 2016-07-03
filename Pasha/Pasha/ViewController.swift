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
    var chanel2: [String]?
    var request: Request?
    
    @IBOutlet weak var refreshingControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateChannels()
        
        self.view.subviews
        
        refreshingControl.addTarget(self, action: #selector(ViewController.updateChannels), forControlEvents: UIControlEvents.ValueChanged)
    }

    func isRequestGood(error: NSError?, data: NSData?)-> Bool {
        
        if (error != nil) {
            
            return false
            
        } else {

            
//            if self.chanel2 != nil {
//                let firstItem = self.chanel2![0]
//            } else {
//                print("Error")
//            }

            
//            if let chanel2 = self.chanel2 {
//                let firstItem = chanel2[0]
//            } else {
//                print("Error")
//            }
//
//            let firstItem = self.chanel2![0]
//            let secondItem = self.chanel2?[0]
            //secondItem.capitalizedString
            
            
            
            let xml = SWXMLHash.parse(data!)
            
            self.channels = [Channel](count: xml["rss"]["channel"].all.count, repeatedValue: Channel())
            
            for i in 0 ..< xml["rss"]["channel"].all.count {
                
                if let text = xml["rss"]["channel"][i]["title"].element?.text {
                    self.channels[i].setTitle(text)
                }
                
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
                    
                    self.channels[i].getItem(j).setTitle(xml["rss"]["channel"][i]["item"][j]["title"].element!.text!)
                    self.channels[i].getItem(j).setDescription((xml["rss"]["channel"][i]["item"][j]["description"].element!.text!))
                    self.channels[i].getItem(j).setLink(((xml["rss"]["channel"][i]["item"][j]["link"].element!.text!)))
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
                        "Check you internet connection", preferredStyle: UIAlertControllerStyle.Alert)
                    
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("channel")! as UITableViewCell
        
        cell.textLabel?.text = channels[indexPath.row].getTitle()
        cell.imageView?.image = channels[indexPath.row].getImage()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? NewsController {
            if let indexPath = tableView.indexPathForSelectedRow {                
                controller.channel = self.channels[indexPath.row]
            }
//            controller.indexOfChannel = (self.tableView.indexPathForCell((sender as! UITableViewCell))?.row)!
//                controller.channels = self.channels
        }
        
    }

}
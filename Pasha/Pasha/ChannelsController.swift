//
//  ViewController.swift
//  Pasha
//
//  Created by MacBook on 26.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit
import AlamofireImage

class ChannelsController: UITableViewController {

    var channels = [Channel]()
    
    @IBOutlet weak var refreshingControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        loadChannels()
        
        refreshingControl.addTarget(self, action: #selector(ChannelsController.loadChannels), forControlEvents: UIControlEvents.ValueChanged)
        
    }

    func loadChannels() {
        DataBase.shared.loadChannels(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("Channel")! as? ChannelCell {
            
            cell.cellTitle.text = channels[indexPath.row].title
            
            if let url = NSURL(string: channels[indexPath.row].imageLink) {
                cell.cellImageView.af_setImageWithURL(url)
            }
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let controller = segue.destinationViewController as? NewsController, indexPath = tableView.indexPathForSelectedRow {
            controller.news = self.channels[indexPath.row].news
            controller.isFavoritesController = false
            
        }
    }

}
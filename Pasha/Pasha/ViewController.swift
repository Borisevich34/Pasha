//
//  ViewController.swift
//  Pasha
//
//  Created by MacBook on 26.06.16.
//  Copyright © 2016 MacBook. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UITableViewController {

    var channels = ["channel1", "channel2", "channel3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://feeds.bbci.co.uk/news/world/rss.xml", parameters: nil)
            .response { request, response, data, error in
                if (error != nil) {
                    print("Error!")
                } else {
                    print(data!)
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("channel")! as UITableViewCell
        
        cell.textLabel?.text = channels[indexPath.row]
        
        return cell
    }
    
    

}
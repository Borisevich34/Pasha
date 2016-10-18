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
        
        refreshingControl.addTarget(self, action: #selector(ChannelsController.loadChannels), for: UIControlEvents.valueChanged)
        
    }

    func loadChannels() {
        
        DataBase.shared.loadChannels(completion: channelsLoaded)
    }
    
    func channelsLoaded(incomingChannels: [Channel]?) {
        if let incomingChannels = incomingChannels {
            channels.removeAll() //!!!!!
            channels += incomingChannels
            tableView.reloadData()
            
            if refreshingControl.isRefreshing {
                refreshingControl.endRefreshing()
            }
            
        } else {
            let alertController = UIAlertController(title: "Sorry", message:
                "Check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default){(action) in DataBase.shared.loadChannels(completion: self.channelsLoaded)})
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Channel")! as? ChannelCell {
            
            cell.cellTitle.text = channels[indexPath.row].title
            
            if let url = URL(string: channels[indexPath.row].imageLink) {
                cell.cellImageView.af_setImage(withURL: url)
            }
            
            return cell
        }
        else {
            return UITableViewCell()
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NewsController, let indexPath = tableView.indexPathForSelectedRow {
            controller.news = self.channels[indexPath.row].news
            controller.isFavoritesController = false
            
        }
    }

}

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

    var news = [New]()
    var isFavoritesController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
    
    }
    
    override func viewWillAppear(animated: Bool) {
        if isFavoritesController {
            news = DataBase.shared.getFromDataBase()
        }
        else {
            news.forEach { $0.isFromFavorites =  DataBase.shared.titles.contains($0.title) }
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func addToFavorites(sender: AnyObject) {

        if let sender = sender as? UIView , index = (indexPathForViewInCell(sender)?.row) {
            
            let new = news[index]
            if let button = sender as? FavoriteButton {
                
                if new.isFromFavorites {
                    if let positionInTitles = DataBase.shared.titles.indexOf(new.title) {
                        DataBase.shared.removeFromDataBase(positionInTitles)
                        
                    }
                }
                else {
                    DataBase.shared.addToDataBase(new)
                }

                button.isFavorite = !new.isFromFavorites
                
                new.isFromFavorites = !new.isFromFavorites
                
            }
        }
    }
    
    func indexPathForViewInCell(sender: UIView) -> NSIndexPath? {
        let point = sender.convertPoint(CGPointZero, toView: self.tableView)
        return self.tableView.indexPathForRowAtPoint(point)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("New") as? NewCell {
            
            if let url = NSURL(string: news[indexPath.row].imageLink) {
                
                cell.cellImageView!.af_setImageWithURL(url)
                
            }
            
            cell.cellTitle.text = news[indexPath.row].title
            cell.cellSubtitle.text = news[indexPath.row].subtitle

            if !isFavoritesController {
                cell.cellButton.isFavorite = news[indexPath.row].isFromFavorites
            }
            else
            {
                cell.cellButton.enabled = false
                cell.cellButton.hidden = true
            }

            return cell
            
        }
        else {
            
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isFavoritesController
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            DataBase.shared.removeFromDataBase(indexPath.row)
            news = DataBase.shared.getFromDataBase()
            
            self.tableView.reloadData()
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let requestUrl = NSURL(string: news[indexPath.row].link) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}
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

    var items: [Item]?
    var isFavoritesController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10
    
    }
    
    override func viewWillAppear(animated: Bool) {
        if isFavoritesController {
            items = Singleton.dataBase.getFromDataBase()
        }
        else {
            if let goodItems = items {
                for var item in goodItems {
                    item.isFromFavorites = Singleton.dataBase.titles.contains(item.title)
                }
            }
        }
        self.tableView.reloadData()
        //^^ это не очень хорошо
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addToFavorites(sender: AnyObject) {

        if let goodSender = sender as? UIView , let index = (indexPathForViewInCell(goodSender)?.row), let item = items?[index] {
            
            if let button = sender as? CustomButton {
                
                if item.isFromFavorites {
                    if let positionInTitles = Singleton.dataBase.titles.indexOf(item.title) {
                        Singleton.dataBase.removeFromDataBase(positionInTitles)
                        
                    }
                }
                else {
                    Singleton.dataBase.addToDataBase(item)
                }

                button.isFavorite = !item.isFromFavorites
                item.isFromFavorites = !item.isFromFavorites
                
            }
        }
    }
    
    func indexPathForViewInCell(sender: UIView) -> NSIndexPath? {
        let point = sender.convertPoint(CGPointZero, toView: self.tableView)
        return self.tableView.indexPathForRowAtPoint(point)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("item") as? CustomItemCell {
            
            if let string = items?[indexPath.row].imageLink, let url = NSURL(string: string) {
                
                cell.cellImageView!.af_setImageWithURL(url)
                
            }
            
            cell.cellLabel.text = items?[indexPath.row].title ?? " "
            cell.cellSubtitle.text = items?[indexPath.row].description ?? " "

            if !isFavoritesController {
                if let lighting = items?[indexPath.row].isFromFavorites {
                    cell.cellButton.isFavorite = lighting
                }
            }
            else
            {
                cell.cellButton.enabled = false
                cell.cellButton.hidden = true
            }

            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isFavoritesController
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            Singleton.dataBase.removeFromDataBase(indexPath.row)
            
            items = Singleton.dataBase.getFromDataBase()
            self.tableView.reloadData()
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let requestUrl = NSURL(string: items?[indexPath.row].link ?? "") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}
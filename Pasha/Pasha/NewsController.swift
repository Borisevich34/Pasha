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
        
        if isFavoritesController {
            items = Singleton.dataBase.getFromDataBase()
        }
    
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.setItem(items?[indexPath.row] ?? Item())
            
            //if !isFavoritesController
                //если есть в синглтоне то подсветить
            //else cell.button.makeDisable()
            cell.cellButton.highlighted = true
            
            
            
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
            
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let requestUrl = NSURL(string: items?[indexPath.row].link ?? "") {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
}
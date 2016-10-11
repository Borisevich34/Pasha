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
    
    override func viewWillAppear(_ animated: Bool) {
        if isFavoritesController {
            news = DataBase.shared.getFromDataBase()
        }
        else {
            news.forEach { $0.isFromFavorites =  DataBase.shared.titles.contains($0.title) }
        }
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func addToFavorites(sender: AnyObject) {

        if let sender = sender as? UIView , let index = (indexPathForViewInCell(sender: sender)?.row) {
            
            let new = news[index]
            if let button = sender as? FavoriteButton {
                
                if new.isFromFavorites {
                    if let positionInTitles = DataBase.shared.titles.index(of: new.title) {
                        DataBase.shared.removeFromDataBase(index: positionInTitles)
                        
                    }
                }
                else {
                    DataBase.shared.addToDataBase(new: new)
                }

                button.isFavorite = !new.isFromFavorites
                
                new.isFromFavorites = !new.isFromFavorites
                
            }
        }
    }
    
    func indexPathForViewInCell(sender: UIView) -> NSIndexPath? {
        let point = sender.convert(CGPoint.zero, to: self.tableView)
        return self.tableView.indexPathForRow(at: point) as NSIndexPath?
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "New") as? NewCell {
            
            if let url = URL(string: news[indexPath.row].imageLink) {
                
                cell.cellImageView!.af_setImage(withURL: url)
                
            }
            
            cell.cellTitle.text = news[indexPath.row].title
            cell.cellSubtitle.text = news[indexPath.row].subtitle

            if !isFavoritesController {
                cell.cellButton.isFavorite = news[indexPath.row].isFromFavorites
            }
            else
            {
                cell.cellButton.isEnabled = false
                cell.cellButton.isHidden = true
            }

            return cell
            
        }
        else {
            
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isFavoritesController
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            DataBase.shared.removeFromDataBase(index: indexPath.row)
            news = DataBase.shared.getFromDataBase()
            
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let requestUrl = URL(string: news[indexPath.row].link) {
            UIApplication.shared.open(requestUrl, options: [String : Any](), completionHandler: nil)
        }

    }

    
}

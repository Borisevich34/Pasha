import UIKit
import SWXMLHash
import Alamofire

class DataBase {
    
    let story = NSUserDefaults.standardUserDefaults()
    var titles : [String]
    
    static let shared = DataBase()
    
    init () {
        
        if let storyTitles = story.stringArrayForKey("titles") {
            titles = storyTitles
        }
        else {
            titles = [String]()
        }
    }
    
    func addToDataBase(new: New) {
        
        if !story.dictionaryRepresentation().keys.contains(new.title) {
            
            let title = NSKeyedArchiver.archivedDataWithRootObject(new.title)
            let subtitle = NSKeyedArchiver.archivedDataWithRootObject(new.subtitle)
            let imageLink = NSKeyedArchiver.archivedDataWithRootObject(new.imageLink)
            let link = NSKeyedArchiver.archivedDataWithRootObject(new.link)
            
            let object : [NSData] = [title, subtitle, link, imageLink]
            
            story.setObject(object, forKey: new.title)
            
            titles.insert(new.title, atIndex: 0)
            story.setObject(titles, forKey: "titles")
            
            story.synchronize()
            
        }
        
    }

    func getFromDataBase() -> [New] {
        
        let allData = titles.flatMap(story.objectForKey).map{($0 as? [NSData]) ?? [NSData](count: 4, repeatedValue: NSData())}
        let news = allData.map(transformToNew)
        
        return news
    }
    
    func transformToNew(data: [NSData]) -> New {
        
        let new = New()
        let records = data.map{ NSKeyedUnarchiver.unarchiveObjectWithData($0) as? String ?? " " }
        new.title = records[0]
        new.subtitle = records[1]
        new.link = records[2]
        new.imageLink = records[3]
        new.isFromFavorites = true
        
        return new
    }
    
    func removeFromDataBase (index : Int) {
        story.removeObjectForKey(titles.removeAtIndex(index))
        story.setObject(titles, forKey: "titles")
        story.synchronize()

    }
    
    func isRequestGood(channelseController : ChannelsController, error: NSError?, data: NSData?)-> Bool {
        
        if let data = data where error == nil {
            let xml = SWXMLHash.parse(data)
            
            channelseController.channels = [Channel]()
            
            let channel = xml["rss"]["channel"]
            for i in 0 ..< channel.all.count {
                
                if let text = channel[i]["title"].element?.text, imageLink = channel[i]["image"]["url"].element?.text {
                    
                    let channel = Channel()
                    channel.title = text
                    channel.imageLink = imageLink

                    var news = [New]()
                    
                    for j in 0 ..< channel[i]["item"].all.count {
                        
                        let new = New()
                        let item = channel[i]["item"][j]
                        new.title = item["title"].element?.text ?? " "
                        new.subtitle = item["description"].element?.text ?? " "
                        new.link = item["link"].element?.text ?? " "
                        new.imageLink = item["media:thumbnail"].element?.attributes["url"] ?? " "
                        
                        news.append(new)
                    }
                    
                    channel.news = news
                    channelseController.channels.append(channel)
                }
                else {
                    return false
                }
            }
            return true
        }
        else {
            return false
        }
        
        
    }
    
    func loadChannels(channelseController : ChannelsController) {
        
        Alamofire.request(.GET, "http://feeds.bbci.co.uk/news/world/rss.xml", parameters: nil)
            .response { [unowned self] request, response, data, error in
                if !self.isRequestGood(channelseController, error: error, data: data) {
                    
                    let alertController = UIAlertController(title: "Sorry", message:
                        "Check your internet connection", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default){(action) in DataBase.shared.loadChannels(channelseController)})
                    
                    channelseController.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    channelseController.tableView.reloadData()
                    
                    if channelseController.refreshingControl.refreshing {
                        channelseController.refreshingControl.endRefreshing()
                    }
                }
        }
    }
    
}
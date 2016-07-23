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
    
    func isRequestGood(error: NSError?, data: NSData?) -> [Channel]? {
        
        if let data = data where error == nil {
            let xml = SWXMLHash.parse(data)
            
            var channels = [Channel]()
            
            let rssChannel = xml["rss"]["channel"]
            for i in 0 ..< rssChannel.all.count {
                
                if let text = rssChannel[i]["title"].element?.text, imageLink = rssChannel[i]["image"]["url"].element?.text {
                    
                    let channel = Channel()
                    channel.title = text
                    channel.imageLink = imageLink

                    var news = [New]()
                    
                    for j in 0 ..< rssChannel[i]["item"].all.count {
                        
                        let new = New()
                        let item = rssChannel[i]["item"][j]
                        new.title = item["title"].element?.text ?? " "
                        new.subtitle = item["description"].element?.text ?? " "
                        new.link = item["link"].element?.text ?? " "
                        new.imageLink = item["media:thumbnail"].element?.attributes["url"] ?? " "
                        
                        news.append(new)
                    }
                    
                    channel.news = news
                    channels.append(channel)
                }
                else {
                    return nil
                }
            }
            return channels
        }
        else {
            return nil
        }
        
        
    }
    
    func loadChannels(completion: [Channel]? -> Void) {
        
        Alamofire.request(.GET, "http://feeds.bbci.co.uk/news/world/rss.xml", parameters: nil)
            .response { [unowned self] request, response, data, error in
                completion(self.isRequestGood(error, data: data))
        }
    }
    
}
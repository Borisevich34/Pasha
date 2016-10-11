import UIKit
import SWXMLHash
import Alamofire

class DataBase {
    
    let story = UserDefaults.standard
    var titles : [String]
    
    static let shared = DataBase()
    
    init () {
        
        if let storyTitles = story.stringArray(forKey: "titles") {
            titles = storyTitles
        }
        else {
            titles = [String]()
        }
    }
    
    func addToDataBase(new: New) {
        
        if !story.dictionaryRepresentation().keys.contains(new.title) {
            
            let title = NSKeyedArchiver.archivedData(withRootObject: new.title)
            let subtitle = NSKeyedArchiver.archivedData(withRootObject: new.subtitle)
            let imageLink = NSKeyedArchiver.archivedData(withRootObject: new.imageLink)
            let link = NSKeyedArchiver.archivedData(withRootObject: new.link)
            
            let object : [Data] = [title, subtitle, link, imageLink]
            
            story.set(object, forKey: new.title)
            
            titles.insert(new.title, at: 0)
            story.set(titles, forKey: "titles")
            
            story.synchronize()
            
        }
        
    }

    func getFromDataBase() -> [New] {
        
        let allData = titles.flatMap(story.object).map{($0 as? [Data]) ?? [Data](repeating: Data(), count: 4)}
        let news = allData.map(transformToNew)
        
        return news
    }
    
    func transformToNew(data: [Data]) -> New {
        
        let new = New()
        let records = data.map{ NSKeyedUnarchiver.unarchiveObject(with: $0) as? String ?? " " }
        new.title = records[0]
        new.subtitle = records[1]
        new.link = records[2]
        new.imageLink = records[3]
        new.isFromFavorites = true
        
        return new
    }
    
    func removeFromDataBase (index : Int) {
        story.removeObject(forKey: titles.remove(at: index))
        story.set(titles, forKey: "titles")
        story.synchronize()

    }
    
    func isRequestGood(error: Error?, data: Data?) -> [Channel]? {
        
        if let data = data , error == nil {
            let xml = SWXMLHash.parse(data)
            
            var channels = [Channel]()
            
            let rssChannel = xml["rss"]["channel"]
            for i in 0 ..< rssChannel.all.count {
                
                if let text = rssChannel[i]["title"].element?.text, let imageLink = rssChannel[i]["image"]["url"].element?.text {
                    
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
                        new.imageLink = item["media:thumbnail"].element?.allAttributes["url"]?.text ?? " "  //was attributes
                        
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
    
    func loadChannels(completion: @escaping ([Channel]?) -> Void) {

        Alamofire.request("http://feeds.bbci.co.uk/news/world/rss.xml").response { [unowned self] response in
            completion(self.isRequestGood(error: response.error, data: response.data))
        }
    }
    
}

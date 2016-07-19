import UIKit
class Singleton {
    
    let story = NSUserDefaults.standardUserDefaults()
    var titles : [String]
    
    static let dataBase = Singleton()
    
    init () {
        
        if let storyTitles = story.stringArrayForKey("titles") {
            titles = storyTitles
        }
        else {
            titles = [String]()
        }
    }
    
    func addToDataBase(item: Item) {
        
        if !story.dictionaryRepresentation().keys.contains(item.title) {
            
            let title = NSKeyedArchiver.archivedDataWithRootObject(item.title)
            let subtitle = NSKeyedArchiver.archivedDataWithRootObject(item.description)
            let imageLink = NSKeyedArchiver.archivedDataWithRootObject(item.imageLink)
            let link = NSKeyedArchiver.archivedDataWithRootObject(item.link)
            
            let object : [NSData] = [title, subtitle, link, imageLink]
            
            story.setObject(object, forKey: item.title)
            
            titles.insert(item.title, atIndex: 0)
            story.setObject(titles, forKey: "titles")
            
            story.synchronize()
            
        }
        
    }
    
    func getFromDataBase() -> [Item] {
        var items = [Item](count : titles.count, repeatedValue : Item())
        for i in 0 ..< titles.count {
            items[i] = Item()
            if let array = story.objectForKey(titles[i]) as? [NSData] {
                
                items[i].title = NSKeyedUnarchiver.unarchiveObjectWithData(array[0]) as? String ?? ""
                items[i].description = NSKeyedUnarchiver.unarchiveObjectWithData(array[1]) as? String ?? ""
                items[i].link = NSKeyedUnarchiver.unarchiveObjectWithData(array[2]) as? String ?? ""
                items[i].imageLink = NSKeyedUnarchiver.unarchiveObjectWithData(array[3]) as? String ?? ""
                items[i].isFromFavorites = true
                
            }
        }
        return items
    }
    
    func removeFromDataBase (index : Int) {
        story.removeObjectForKey(titles.removeAtIndex(index))
        story.setObject(titles, forKey: "titles")
        story.synchronize()

    }
    
    
}
//
//  Event.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    let name: String?
    let address: String?
    let lat: NSNumber?
    let lon: NSNumber?
    let imageUrl: URL?
    let eventDate: Date?
    let ticketMinPrice: Float?
    let ticketMaxPrice: Float?
    let totalTickets: Int?
    let locale: String?
    let id: Int?
    
    init(dictionary: NSDictionary) {
        print(dictionary)
        
        name = dictionary["name"] as? String
        id = dictionary["id"] as? Int
        let location = dictionary["venue"] as? NSDictionary
        var addressString = ""
        if location != nil {
            addressString = location?.object(forKey: "address1") as! String
        }
        address = addressString
        lat = location?.object(forKey: "latitude") as? NSNumber
        lon = location?.object(forKey: "longitude") as? NSNumber
        
        let imagesArray = dictionary["images"] as? NSArray
        let imageDict = imagesArray?[0] as? NSDictionary
        let imageUrlString = imageDict?["urlSsl"] as? String
        if imageUrlString != nil {
            imageUrl = URL(string: imageUrlString!)!
        } else {
            imageUrl = nil
        }
        
        let formatter = DateFormatter()
        locale = dictionary.object(forKey: "defaultLocale") as? String
        formatter.locale = Locale(identifier: locale!)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        eventDate = formatter.date(from: dictionary.object(forKey: "eventDateLocal") as! String)
        //print(formatter.string(from: eventDate!))
        
        let ticketInfo = dictionary["ticketInfo"] as? NSDictionary
        ticketMinPrice = ticketInfo?.object(forKey: "minPrice") as? Float
        ticketMaxPrice = ticketInfo?.object(forKey: "maxPrice") as? Float
        totalTickets = ticketInfo?.object(forKey: "totalTickets") as? Int

    }
    
    class func events(array: [NSDictionary]) -> [Event] {
        var events = [Event]()
        for dictionary in array {
            let event = Event(dictionary: dictionary)
            events.append(event)
        }
        return events
    }
    
    class func searchWithTerm(term: String, completion: @escaping ([Event]?, Error?) -> Void) {
        _ = StubhubClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: String?, categories: [String]?, deals: Bool?, start: Int?, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        _ = StubhubClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, start: start, completion: completion)
    }
}

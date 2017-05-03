//
//  Event.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import CoreLocation
import EVReflection

extension Event: EVReflectable { }

class Event: NSObject {
    
    var name: String?
    var address: String?
    var lat: NSNumber?
    var lon: NSNumber?
    var imageUrlString: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var eventDate: Date?
    var ticketMinPrice: NSNumber?
    var ticketMaxPrice: NSNumber?
    var totalTickets: NSNumber?
    var currencyCode: String?
    var locale: String?
    var id: NSNumber?
    var comment: String
    var eventUrlString: String?
    
    init(dictionary: NSDictionary) {
        //print(dictionary)
        
        name = dictionary["name"] as? String
        id = dictionary["id"] as? NSNumber
        let urlString = dictionary["webURI"] as? String
        eventUrlString = "https://www.stubhub.com/\(urlString!)"
        let location = dictionary["venue"] as? NSDictionary
        var addressString = ""
        if location != nil {
            addressString = location?["address1"] as! String
        }
        address = addressString
        
        lat = location?["latitude"] as? NSNumber
        lon = location?["longitude"] as? NSNumber
        
        let imagesArray = dictionary["images"] as? NSArray
        let imageDict = imagesArray?[0] as? NSDictionary
        imageUrlString = imageDict?["urlSsl"] as? String
        imageWidth = imageDict?["width"] as? NSNumber
        imageHeight = imageDict?["height"] as? NSNumber
        let formatter = DateFormatter()
        locale = dictionary["defaultLocale"] as? String
        formatter.locale = Locale(identifier: locale!)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        eventDate = formatter.date(from: dictionary["eventDateLocal"] as! String)
        //print(formatter.string(from: eventDate!))
        
        let ticketInfo = dictionary["ticketInfo"] as? NSDictionary
        ticketMinPrice = ticketInfo?["minPrice"] as? NSNumber
        ticketMaxPrice = ticketInfo?["maxPrice"] as? NSNumber
        totalTickets = ticketInfo?["totalTickets"] as? NSNumber
        currencyCode = ticketInfo?["currencyCode"] as? String

        let dformatter = DateFormatter()
        dformatter.locale = Locale(identifier: locale!)
        dformatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
        let date = dformatter.string(from: eventDate!)
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .currency
        nFormatter.maximumFractionDigits = 2;
        nFormatter.locale = Locale(identifier: locale!)
        let priceRange = nFormatter.string(from: ticketMinPrice! as NSNumber)!+"-"+nFormatter.string(from: ticketMaxPrice! as NSNumber)!
        comment = "\(address!)\n\(date)\n\(priceRange)"

    }
    
    override init() {
        self.name = nil
        self.address = nil
        self.lat = nil
        self.lon = nil
        self.imageUrlString = nil
        self.imageWidth = nil
        self.imageHeight = nil
        self.eventDate = nil
        self.ticketMinPrice = nil
        self.ticketMaxPrice = nil
        self.totalTickets = nil
        self.currencyCode = nil
        self.locale = nil
        self.id = nil
        self.comment = ""
        self.eventUrlString = nil
    }
    
    class func events(array: [NSDictionary]) -> [Event] {
        var events = [Event]()
        for dictionary in array {
            let event = Event(dictionary: dictionary)
            events.append(event)
        }
        return events
    }
    
    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: comment).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
    class func searchWith(q: String, completion: @escaping ([Event]?, Error?) -> Void) {
        _ = StubhubClient.sharedInstance.searchWith(q, completion: completion)
    }
    
    class func searchWith(q: String, sort: String?, start: Int?, point: CLLocationCoordinate2D?, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        _ = StubhubClient.sharedInstance.searchWith(q, sort: sort, start: start, point: point, completion: completion)
    }
}


//
//  Event.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import CoreLocation

class Event: NSObject {
    
    let name: String?
    let address: String?
    let lat: NSNumber?
    let lon: NSNumber?
    let imageUrl: URL?
    //let image: UIImage?
    let imageSize: CGSize
    let eventDate: Date?
    let ticketMinPrice: Float?
    let ticketMaxPrice: Float?
    let totalTickets: Int?
    let currencyCode: String?
    let locale: String?
    let id: Int?
    let comment: String
    let eventUrl: URL?
    
    init(dictionary: NSDictionary) {
        //print(dictionary)
        
        name = dictionary["name"] as? String
        id = dictionary["id"] as? Int
        if let eventUrlString = dictionary["webURI"] as? String {
            eventUrl = URL(string: "https://www.stubhub.com/\(eventUrlString)")
        } else {
            eventUrl = nil
        }
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
        let imageUrlString = imageDict?["urlSsl"] as? String
        if imageUrlString != nil {
            imageUrl = URL(string: imageUrlString!)!
        } else {
            imageUrl = nil
        }
        let width = imageDict?["width"] as? CGFloat
        let height = imageDict?["height"] as? CGFloat
        imageSize = CGSize(width: width!, height: height!)
        /*
        var imageData: Data? = nil
        do {
            imageData = try Data(contentsOf: imageUrl!)
        } catch {
            print(error.localizedDescription)
        }
        image = UIImage(data: imageData!)
        */
        let formatter = DateFormatter()
        locale = dictionary["defaultLocale"] as? String
        formatter.locale = Locale(identifier: locale!)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        eventDate = formatter.date(from: dictionary["eventDateLocal"] as! String)
        //print(formatter.string(from: eventDate!))
        
        let ticketInfo = dictionary["ticketInfo"] as? NSDictionary
        ticketMinPrice = ticketInfo?["minPrice"] as? Float
        ticketMaxPrice = ticketInfo?["maxPrice"] as? Float
        totalTickets = ticketInfo?["totalTickets"] as? Int
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

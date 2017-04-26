//
//  StubhubClient.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import BDBOAuth1Manager
import Alamofire

// You can register for stubhub API keys here: http://www.developer.stubhub.com
let stubhubToken = "9139ea53-821c-3d91-8624-a7470334e679"
let urlString = "https://api.stubhub.com/search/catalog/events/v3"

class StubhubClient: NSObject {
    var appToken: String!
    var baseUrlString: String!
    var numFound: Int?

    static let sharedInstance = StubhubClient(baseUrlString: urlString, appToken: stubhubToken, numFound: nil)
    
    init(baseUrlString: String!, appToken: String!, numFound: Int?) {
        self.appToken = appToken
        self.baseUrlString = baseUrlString
        self.numFound = numFound
    }
    
    func searchWith(_ q: String, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        return searchWith(q, sort: nil,  start: nil, point: nil, completion: completion)
    }

    func searchWith(_ q: String, sort: String?, start: Int?, point: CLLocationCoordinate2D?, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        
        // valid sort fields: popularity, eventDateLocal, distance with desc or asc order
        var parameters: Parameters = ["minAvailableTickets":1, "rows":20, "sort":"eventDateLocal asc"]
        let header: HTTPHeaders = ["Authorization": "Bearer \(appToken!)"]
        let parameterEncoding = URLEncoding(destination: .queryString)
        
        if sort != nil {
            parameters["sort"] = sort! as Any
        }
        /*
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as Any
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as Any
        }
        */
        if start != nil {
            if start! >= self.numFound! {
                // TODO: some error
            }
            parameters["start"] = start! as Any
        }
        
        if point != nil {
            let lat = point?.latitude
            let lon = point?.longitude
            let latlon: String = "\(lat!),\(lon!)"
            parameters["point"] = latlon
            parameters["radius"] = 200
        } else {
            parameters["city"] = "New York"
        }

        Alamofire.request(
            URL(string: baseUrlString)!,
            method: .get,
            parameters: parameters,
            encoding: parameterEncoding,
            headers: header)
        .validate()
        .responseJSON { (response) -> Void in
            guard response.result.isSuccess else {
                print("Error while fetching events: \(response.result.error!)")
                completion(nil, nil)
                return
            }
            
            guard let value = response.result.value as? [String: Any],
                let dictionaries = value["events"] as? [NSDictionary] else {
                    print("Malformed data received from stubhub service")
                    completion(nil, nil)
                    return
            }
            
            self.numFound = value["numFound"] as? Int
            
            completion(Event.events(array: dictionaries), nil)
            
        }
    }
}

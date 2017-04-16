//
//  StubhubClient.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/6/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

import AFNetworking
import BDBOAuth1Manager
import Alamofire

// You can register for stubhub API keys here: http://www.developer.stubhub.com
let stubhubToken = "9139ea53-821c-3d91-8624-a7470334e679"
let urlString = "https://api.stubhub.com/search/catalog/events/v3"

class StubhubClient: NSObject {
    var appToken: String!
    var baseUrlString: String!

    static let sharedInstance = StubhubClient(baseUrlString: urlString, appToken: stubhubToken)
    
    init(baseUrlString: String!, appToken: String!) {
        self.appToken = appToken
        self.baseUrlString = baseUrlString
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, start: nil, completion: completion)
    }

    func searchWithTerm(_ term: String, sort: String?, categories: [String]?, deals: Bool?, start: Int?, completion: @escaping ([Event]?, Error?) -> Void) -> Void {
        
        // valid sort fields: popularity, eventDateLocal, distance
        var parameters: Parameters = ["minAvailableTickets":1, "city":"New York", "sort":"eventDateLocal desc"]
        let header: HTTPHeaders = ["Authorization": "Bearer \(appToken!)"]
        let parameterEncoding = URLEncoding(destination: .queryString)
        
        if sort != nil {
            parameters["sort"] = sort! as Any
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joined(separator: ",") as Any
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals! as Any
        }
        
        if start != nil {
            parameters["start"] = start! as Any
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
            
            //print(dictionaries)
            completion(Event.events(array: dictionaries), nil)
            
        }
    }
}

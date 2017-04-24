//
//  PhotoAnnotation.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 4/23/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var photo: UIImage!
    
    var title: String?
    var comment: String?
    
    
    
}

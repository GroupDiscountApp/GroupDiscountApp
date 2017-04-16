//
//  EventsCell.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

class EventsCell: UICollectionViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
        }
    }
    
    var event: Event! {
        didSet {
            nameLabel.text = event.name
            thumbImageView.setImageWith(event.imageUrl!)
            categoriesLabel.text = "# tickets: \(event.totalTickets!)"
            addressLabel.text = event.address
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: event.locale!)
            formatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
            reviewsCountLabel.text = formatter.string(from: event.eventDate!)
            //ratingImageView.setImageWith(business.ratingImageURL!)
            let nFormatter = NumberFormatter()
            nFormatter.numberStyle = .currency
            nFormatter.maximumFractionDigits = 2;
            nFormatter.locale = Locale(identifier: event.locale!)
            distanceLabel.text = nFormatter.string(from: event.ticketMinPrice! as NSNumber)!+"-"+nFormatter.string(from: event.ticketMaxPrice! as NSNumber)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    

}

//
//  EventsViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        /*
        nameLabel.text = event.name
        thumbImageView.setImageWith(event.imageURL!)
        categoriesLabel.text = event.categories
        addressLabel.text = event.address
        reviewsCountLabel.text = "\(event.reviewCount!) Reviews"
        ratingImageView.setImageWith(event.ratingImageURL!)
        distanceLabel.text = event.distance
        */
        nameLabel.text = event.name
        thumbImageView.setImageWith(event.imageUrl!)
        categoriesLabel.text = "# tickets: \(event.totalTickets!)"
        addressLabel.text = event.address
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: event.locale!)
        formatter.dateFormat = "EEEE, MMMM dd, yyyy' at 'h:mm a"
        reviewsCountLabel.text = formatter.string(from: event.eventDate!)
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .currency
        nFormatter.maximumFractionDigits = 2;
        nFormatter.locale = Locale(identifier: event.locale!)
        distanceLabel.text = nFormatter.string(from: event.ticketMinPrice! as NSNumber)!+"-"+nFormatter.string(from: event.ticketMaxPrice! as NSNumber)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "listGroupsSegue" {
            let vc = segue.destination as! GroupsViewController
            vc.event = event
        }
    }
    

}

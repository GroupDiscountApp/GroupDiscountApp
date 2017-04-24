//
//  GroupViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var groupId: String!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventNameLabel.text = event.name
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
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            chatVC.groupId = groupId
        }
    }
 

}

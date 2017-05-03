//
//  GroupViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD

class GroupViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var numberUsersLabel: UILabel!
    //@IBOutlet weak var usersListLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var group: PFObject?
    var groupId: String!
    var groupName: String!
    var event: Event!
    var going: Bool = false
    var users: [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl!.addTarget(self, action: #selector(GroupViewController.loadGroup), for: .valueChanged)
        
        eventNameLabel.text = event.name
        eventDescriptionLabel.text = event.comment
        eventImageView.setImageWith(URL(string: event.imageUrlString!)!)
        
        loadGroup()
    }
    
    func loadGroup() {
        var query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.includeKey(PF_GROUPS_USERS)
        query.whereKey("objectId", equalTo: groupId)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let group = objects!.first {
                    self.group = group
                    let users = group[PF_GROUPS_USERS] as! [PFUser]
                    self.users = users
                    let currentUser = PFUser.current()
                    for user in users {
                        if user.objectId == currentUser?.objectId {
                            self.going = true
                        }
                    }
                    self.goingSwitch.setOn(self.going, animated: true)
                    self.tableView.reloadData()
                    self.numberUsersLabel.text = "Number going: \(users.count)"
                }
            }  else {
                ProgressHUD.showError("Network error")
                print(error! as NSError)
            }
            self.tableView.refreshControl!.endRefreshing()
        }

    }
    
    @IBAction func goingSwitchToggled(_ sender: UISwitch) {
        users = group?[PF_GROUPS_USERS] as! [PFUser]
        
        if sender.isOn && !going {
            users?.append(PFUser.current()!)
            var user = PFUser.current()!
            var userEvents = user[PF_USER_EVENTS] as? [String]
            userEvents!.append(event.toJsonString())
            user[PF_USER_EVENTS] = userEvents
            user.saveInBackground()
            
        } else if !sender.isOn && going {
            let currentUser = PFUser.current()
            for user in users! {
                if user.objectId == currentUser?.objectId {
                    users?.remove(at: (users?.index(of: user)!)!)
                    var user = PFUser.current()!
                    var userEvents = user[PF_USER_EVENTS] as? [String]
                    if userEvents!.count > 0 {
                        let eventJson = event.toJsonString()
                        if let index = userEvents!.index(of: eventJson) {
                            userEvents!.remove(at: index)
                            user[PF_USER_EVENTS] = userEvents
                            user.saveInBackground()
                        }
                    }
                }
            }
        }
        
        if users?.count == 0 {
            do {
                try group?.delete()
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            self.numberUsersLabel.text = "Number going: \((users?.count)!)"
            going = sender.isOn
            group?[PF_GROUPS_USERS] = users
            group?.saveInBackground()
        }
        tableView.reloadData()
        
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
            Messages.createMessageItem(user: PFUser.current()!, groupId: groupId, description: groupName)
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            chatVC.groupId = groupId
        }
    }
 

}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let user = users?[indexPath.row]
        cell.textLabel?.text = user?[PF_USER_FULLNAME] as? String
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
}

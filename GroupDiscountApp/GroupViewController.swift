//
//  GroupViewController.swift
//  GroupDiscountApp
//
//  Created by Palak Jadav on 3/20/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse

class GroupViewController: UITableViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var goingSwitch: UISwitch!
    @IBOutlet weak var numberUsersLabel: UILabel!
    @IBOutlet weak var usersListLabel: UILabel!
    
    var group: PFObject?
    var groupId: String!
    var groupName: String!
    var event: Event!
    var going: Bool = false
    var users: [PFUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        eventNameLabel.text = event.name
        eventDescriptionLabel.text = event.comment
        eventImageView.setImageWith(event.imageUrl!)
        
        var query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.includeKey(PF_GROUPS_USERS)
        query.whereKey("objectId", equalTo: groupId)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let group = objects!.first {
                self.group = group
                let users = group[PF_GROUPS_USERS] as! [PFUser]
                let currentUser = PFUser.current()
                for user in users {
                    if user.objectId == currentUser?.objectId {
                        self.going = true
                    }
                }
                self.goingSwitch.setOn(self.going, animated: true)
                //self.tableView.reloadData()
                self.numberUsersLabel.text = "\(users.count)"
                var num = 1
                var userList = ""
                for user in users {
                     userList += "\(num). \(user[PF_USER_FULLNAME]!)\n"
                    num += 1
                }
                self.usersListLabel.text = userList
            }
        }
    }
/*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0, 1:
            return 1
        case 2:
            var count: Int = 1
            if let users = users {
                count += users.count
            }
            return count
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let section = indexPath.section
        switch section {
        case 0, 1:
            break
        case 2:
            let userName = users?[indexPath.row]
            cell.detailTextLabel?.text = "\(userName)"
        default:
            break
        }
        return cell

    }
*/
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    
    @IBAction func goingSwitchToggled(_ sender: UISwitch) {
        var users = group?[PF_GROUPS_USERS] as! [PFUser]
        var userList = usersListLabel.text!
        if sender.isOn && !going {
            users.append(PFUser.current()!)
            userList += "\(users.count). \(PFUser.current()![PF_USER_FULLNAME]!)\n"
            usersListLabel.text = userList
            var user = PFUser.current()!
            var userEvents = user[PF_USER_EVENTS] as! [Event]
            userEvents.append(event)
            user[PF_USER_EVENTS] = userEvents
            user.saveInBackground()
            
        } else if !sender.isOn && going {
            let currentUser = PFUser.current()
            for user in users {
                if user.objectId == currentUser?.objectId {
                    users.remove(at: users.index(of: user)!)
                    //usersListLabel.text = userList.components(separatedBy: "\n")[0...(users.count)].joined(separator: "\n")
                    var num = 1
                    var userList = ""
                    for user in users {
                        userList += "\(num). \(user[PF_USER_FULLNAME]!)\n"
                        num += 1
                    }
                    self.usersListLabel.text = userList
                    var user = PFUser.current()!
                    var userEvents = user[PF_USER_EVENTS] as! [Event]
                    userEvents.remove(at: userEvents.index(of: event)!)
                    user[PF_USER_EVENTS] = userEvents
                    user.saveInBackground()
                }
            }
        }
        if users.count == 0 {
            do {
                try group?.delete()
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            self.numberUsersLabel.text = "\(users.count)"
            going = sender.isOn
            group?[PF_GROUPS_USERS] = users
            group?.saveInBackground()
        }
        
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

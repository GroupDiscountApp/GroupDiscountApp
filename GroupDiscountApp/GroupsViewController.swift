//
//  GroupsViewController.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 3/31/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD

class GroupsViewController: UITableViewController, UIAlertViewDelegate {
    
    var groups: [PFObject]! = []
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(GroupsViewController.loadGroups), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(target: self)
        }
    }
    
    func loadGroups() {
        var query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.whereKey(PF_GROUPS_EVENT_ID, equalTo: event.id)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                self.groups.removeAll()
                self.groups.append(contentsOf: objects!)
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error! as NSError)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    @IBAction func newButtonPressed(_ sender: UIBarButtonItem) {
        self.actionNew()
    }
    
    func actionNew() {
        var alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            var textField = alertView.textField(at: 0);
            if let text = textField!.text {
                if text.characters.count > 0 {
                    var object = PFObject(className: PF_GROUPS_CLASS_NAME)
                    object[PF_GROUPS_NAME] = text
                    object[PF_GROUPS_EVENT_ID] = event.id
                    object.saveInBackground(block: { (success: Bool, error: Error?) in
                        if success {
                            self.loadGroups()
                        } else {
                            ProgressHUD.showError("Network error")
                            print(error! as NSError)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        var group = self.groups[indexPath.row]
        cell.textLabel?.text = group[PF_GROUPS_NAME] as? String
        
        var query = PFQuery(className: PF_CHAT_CLASS_NAME)
        query.whereKey(PF_CHAT_GROUPID, equalTo: group.objectId!)
        query.order(byDescending: PF_CHAT_CREATEDAT)
        query.limit = 1000
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let chat = objects!.first {
                let date = NSDate()
                let seconds = date.timeIntervalSince(chat.createdAt!)
                let elapsed = Utilities.timeElapsed(seconds: seconds);
                let countString = (objects!.count > 1) ? "\(objects!.count) messages" : "\(objects!.count) message"
                cell.detailTextLabel?.text = "\(countString) \(elapsed)"
            } else {
                cell.detailTextLabel?.text = "0 messages"
            }
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var group = self.groups[indexPath.row]
        let groupId = group.objectId! as String
        
        Messages.createMessageItem(user: PFUser.current()!, groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        self.performSegue(withIdentifier: "groupDetailSegue", sender: groupId )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupDetailSegue" {
            let vc = segue.destination as! GroupViewController
            let groupId = sender as! String
            vc.groupId = groupId
            vc.event = event
        }
        /*
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
        */
    }
}
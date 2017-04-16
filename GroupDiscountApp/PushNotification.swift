//
//  PushNotification.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 3/29/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import Foundation
import Parse

class PushNotication {
    
    class func parsePushUserAssign() {
        var installation = PFInstallation.current()
        installation?[PF_INSTALLATION_USER] = PFUser.current()
        installation?.saveInBackground { (succeeded: Bool, error: Error?) in
            if error != nil {
                print("parsePushUserAssign save error.")
            }
        }
    }
    
    class func parsePushUserResign() {
        var installation = PFInstallation.current()
        installation?.remove(forKey: PF_INSTALLATION_USER)
        installation?.saveInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print("parsePushUserResign save error")
            }
        }
    }
    
    class func sendPushNotification(groupId: String, text: String) {
        var query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.includeKey(PF_MESSAGES_USER)
        query.limit = 1000
        
        var installationQuery = PFInstallation.query()
        installationQuery!.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, in: query)
        
        var push = PFPush()
        push.setQuery(installationQuery as? PFQuery<PFInstallation>)
        push.setMessage(text)
        push.sendInBackground { (succeeded: Bool, error: Error?) in
            if error != nil {
                print("sendPushNotification error")
            }
        }
    }
    
}

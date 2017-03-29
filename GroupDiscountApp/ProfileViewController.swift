//
//  ProfileViewController.swift
//  GroupDiscountApp
//
//  Created by Dwayne Johnson on 3/27/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: UIButton) {
        
        PFUser.logOutInBackground { (error: Error?) in
            print("current user: \(PFUser.current())")
        }
        
        //returns to main view controller : "Login"
        DispatchQueue.main.async(execute: { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
            self.present(viewController, animated: true, completion: nil)
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ProfileViewController.swift
//  GroupDiscountApp
//
//  Created by Dwayne Johnson on 3/27/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ProgressHUD

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentUser = PFUser.current() {
            self.loadUser()
        } else {
            Utilities.loginUser(target: self)
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.layer.masksToBounds = true;
        imageButton.layer.cornerRadius = userImageView.frame.size.width / 2;
        imageButton.layer.masksToBounds = true;
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadUser() {
        var user = PFUser.current()
        if let user = user {
            userImageView.file = user[PF_USER_PICTURE] as? PFFile
            
            userImageView.load { (image: UIImage?, error: Error?) in
                if error != nil {
                    print(error! as NSError)
                }
            }
            
            nameField.text = user[PF_USER_FULLNAME] as! String
        }
    }
    
    func saveUser() {
        let fullName = nameField.text
        if (fullName?.characters.count)! > 0 {
            var user = PFUser.current()!
            user[PF_USER_FULLNAME] = fullName
            user[PF_USER_FULLNAME_LOWER] = fullName?.lowercased()
            user.saveInBackground { (succeeded: Bool, error: Error?) in
                if error == nil {
                    ProgressHUD.showSuccess("Saved")
                } else {
                    ProgressHUD.showError("Network error")
                }
            }
        } else {
            ProgressHUD.showError("Name field must not be empty")
        }
    }
    
    // MARK: - User actions
    
    func cleanup() {
        userImageView.image = UIImage(named: "profile_blank")
        nameField.text = nil;
    }
    
    func logout() {
        var actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Log out")
        actionSheet.show(from: (self.tabBarController?.tabBar)!)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        self.logout()
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            PFUser.logOut()
            PushNotication.parsePushUserResign()
            Utilities.postNotification(notification: NOTIFICATION_USER_LOGGED_OUT)
            self.cleanup()
            Utilities.loginUser(target: self)
        }
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        _ = Camera.shouldStartPhotoLibrary(target: self, canEdit: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.dismissKeyboard()
        self.saveUser()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        if image.size.width > 280 {
            image = Images.resizeImage(image: image, width: 280, height: 280)!
        }
        
        var pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6)!)
        pictureFile?.saveInBackground { (succeeded: Bool, error: Error?) in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        userImageView.image = image
        
        if image.size.width > 60 {
            image = Images.resizeImage(image: image, width: 60, height: 60)!
        }
        
        var thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6)!)
        thumbnailFile?.saveInBackground { (succeeded: Bool, error: Error?) in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        var user = PFUser.current()!
        user[PF_USER_PICTURE] = pictureFile
        user[PF_USER_THUMBNAIL] = thumbnailFile
        user.saveInBackground { (succeeded: Bool, error: Error?) in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

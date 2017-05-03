//
//  SignupViewController.swift
//  GroupDiscountApp
//
//  Created by Dwayne Johnson on 3/27/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ProgressHUD

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userImageView: PFImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.layer.masksToBounds = true;
        imageButton.layer.cornerRadius = userImageView.frame.size.width / 2;
        imageButton.layer.masksToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        _ = Camera.shouldStartPhotoLibrary(target: self, canEdit: true)
    }
    
    @IBAction func onCreateAccountButton(_ sender: UIButton) {
        let name = firstNameField.text! + " " + lastNameField.text!
        let email = emailAddressField.text
        let password = passwordField.text
        
        if name.characters.count == 0 {
            ProgressHUD.showError("Name must be set.")
            return
        }
        if password?.characters.count == 0 {
            ProgressHUD.showError("Password must be set.")
            return
        }
        if email?.characters.count == 0 {
            ProgressHUD.showError("Email must be set.")
            return
        }
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        var user = PFUser()
        user.username = email
        user.password = password
        user.email = email
        user[PF_USER_EMAILCOPY] = email
        user[PF_USER_FULLNAME] = name
        user[PF_USER_FULLNAME_LOWER] = name.lowercased()
        user[PF_USER_EVENTS] = []
        user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error == nil {
                PushNotication.parsePushUserAssign()
                ProgressHUD.showSuccess("Succeeded.")
                self.dismiss(animated: true, completion: nil)
            } else {
                if let userInfo = (error as NSError?)?.userInfo {
                    ProgressHUD.showError(userInfo["error"] as! String)
                }
            }
        }

    }
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginView")
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

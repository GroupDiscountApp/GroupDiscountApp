//
//  SignupViewController.swift
//  GroupDiscountApp
//
//  Created by Dwayne Johnson on 3/27/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChangeImage(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func onCreateAccountButton(_ sender: UIButton) {
        /*
        let newUser = PFUser()
        let alert = UIAlertController(title: "Error", message: "This Username already exists" , preferredStyle: .alert)
        
        newUser.username = emailAddressField.text ??  ""
        newUser.password = passwordField.text ?? ""
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Created a user")
                self.performSegue(withIdentifier: "createUserAndLoginSegue", sender: nil)
                
            } else {
                print(error!.localizedDescription)
                let defaultAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        */
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
        
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = originalImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        
        let resizeImageView = UIImageView(frame: CGRect(x : 0, y : 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

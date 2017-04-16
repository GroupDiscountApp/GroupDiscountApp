//
//  Camera.swift
//  GroupDiscountApp
//
//  Created by Calvin Chu on 3/29/17.
//  Copyright © 2017 GroupDiscountApp. All rights reserved.
//

import UIKit
import MobileCoreServices

class Camera {
    
    class func shouldStartCamera(target: AnyObject, canEdit: Bool, frontFacing: Bool) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false {
            return false
        }
        
        let type = kUTTypeImage as String
        let cameraUI = UIImagePickerController()
        
        let available = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) && ((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera))?.contains(type))!
        
        if available {
            cameraUI.mediaTypes = [type]
            cameraUI.sourceType = UIImagePickerControllerSourceType.camera
            
            /* Prioritize front or rear camera */
            if (frontFacing == true) {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.front
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.rear
                }
            } else {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.rear
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerControllerCameraDevice.front
                }
            }
        } else {
            return false
        }
        
        cameraUI.allowsEditing = canEdit
        cameraUI.showsCameraControls = true
        if target is ChatViewController {
            cameraUI.delegate = target as! ChatViewController
        } else if target is ProfileViewController {
            cameraUI.delegate = target as! ProfileViewController
        }
        target.present(cameraUI, animated: true, completion: nil)
        
        return true
    }
    
    class func shouldStartPhotoLibrary(target: AnyObject, canEdit: Bool) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return false
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && ((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary))?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) && ((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum))?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        else {
            return false
        }
        
        imagePicker.allowsEditing = canEdit
        if target is ChatViewController {
            imagePicker.delegate = target as! ChatViewController
        } else if target is ProfileViewController {
            imagePicker.delegate = target as! ProfileViewController
        }
        target.present(imagePicker, animated: true, completion: nil)
        
        return true
    }
    
    class func shouldStartVideoLibrary(target: AnyObject, canEdit: Bool) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return false
        }
        
        let type = kUTTypeMovie as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && ((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary))?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) && ((UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum))?.contains(type))! {
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        else {
            return false
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = target as! ChatViewController
        target.present(imagePicker, animated: true, completion: nil)
        
        return true
    }
}

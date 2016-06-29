//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Liya Wu-17 on 6/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    //View controller on which AlertViewControler and UIImagePickerControler are presented
    
    //stores a weak reference to a UIViewController -> weak reference because the PhotoTakingHeelper does not own the referenced view controller
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    //initializer of this class receives the view controller on which we will present other view controllers and the callback that will call as soon as a user has picked an image
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        //presents the dialog that allows users to choose between their camera and their photo library
        showPhotoSourceSelection()
        
    }
    
    func showPhotoSourceSelection(){
        //Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        //.ActionSheet option we create a popup that gets displayed from the bottom edge of the screen
        
        //allows the user to close the popup without any action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                    self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Depending on the sourceType the UIImagePickerController will activate the camera and display a photo taking overlay - or will show the user's photo library. Our showImagePickerController method takes the sourceType as an argument and hands it on to the imagePickerController - that allows the caller of this method to specify whether the camera or the photo library should be used as an image source.
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController() //method creates a UIImagePickerController
        imagePickerController!.sourceType = sourceType //set the sourceType of that controller
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //called when an image is selected
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image) //hands the image that has been selected as an argument -- TimelineViewController will have recieved the image through its callback closure
    }
    
    //called when the cancel button is tapped
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil) //hides the image picker controller by calling dismiss ViewControllerAnimated on viewController
    }
}

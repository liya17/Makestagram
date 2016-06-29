//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Liya Wu-17 on 6/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        //if we return true the tab bar will behave as usual and present the view controller that the user has selected 
        //if we return false the view controller will not be displayed - exactly the behavior that we want from the Photo Tab Bar Item
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        }
        
        else {
            return true
        }
    }
    
    func takePhoto(){
        //instantiate photo taking class, provide callback for when photo is selected
        //creating an instance of the PhotoTakingHelper
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) {
            
            //closure "in" keyword marks the beginning of the closure
            //closure is outside of the argument list - trailing closure
            (image: UIImage?) in
            print("received a callback")
        }
    }
}
//
//  MenuTableViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/19/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit
import Foundation


class MenuTableViewController: UITableViewController {
  
  var networkController : NetworkController!
 
  override func viewDidLoad() {
        super.viewDidLoad()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    self.networkController = appDelegate.networkController
    

    }

  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    self.navigationController?.delegate = nil
    
    //once app loads, check to see if there is an access token
    if networkController.accessToken == nil {
      networkController.fetchAccessToken()
    }
    
    
  }
  
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

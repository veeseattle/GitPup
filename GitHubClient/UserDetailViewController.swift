//
//  UserDetailViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/22/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var userPhoto: UIImageView!
  @IBOutlet weak var userName: UILabel!
  
  var selectedUser : User!
  var userDetail : [String : AnyObject]!
  var lines = [String]()
  var networkController = NetworkController()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      self.userName.text = selectedUser.userName
      self.userPhoto.image = selectedUser.userPhoto!
      self.tableView.delegate = self
      self.tableView.dataSource = self
      
      self.networkController.fetchSingleUser(selectedUser.userName, callback: { (user, statusCode) -> (Void) in
            self.userDetail = user
        
          for (key, value) in self.userDetail {
            if let dictVal = value as? String {
              if !dictVal.isEmpty {
                var line = "\(key): \(dictVal)"
                self.lines.append(line)
              }
            }
          }
        
          self.tableView.reloadData()
      })

  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.lines.count
  }
      
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("USER_DETAIL", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel!.text = self.lines[indexPath.row]
  
    return cell
  }
  
  
  
  
  
}
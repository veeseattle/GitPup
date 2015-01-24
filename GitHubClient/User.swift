//
//  User.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/21/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//


import UIKit


  struct User {
    let userName : String
    let userPhotoURL : String
    var userPhoto : UIImage?
    var url : String
    var htmlURL : String
    
    init (jsonDictionary : [String : AnyObject]) {
      self.userName = jsonDictionary["login"] as String
      self.userPhotoURL = jsonDictionary["avatar_url"] as String
      self.url = jsonDictionary["url"] as String
      self.htmlURL = jsonDictionary["html_url"] as String
    }
  }


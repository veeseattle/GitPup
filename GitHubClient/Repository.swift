//
//  Repository.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/19/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import Foundation

class Repository {
  var name : String
  var author : String
  var url : String
  
  init( name: String, author: String, url : String) {
    self.name = name
    self.author = author
    self.url = url
  }

}
//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/19/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit

class NetworkController {
  
  var urlSession : NSURLSession
  let clientID = "a31f1ccc91fce73d5c22"
  let clientSecret = "08361906f1d3ab0fe25689faf28a6ddf473597b0"
  let accessTokenUserDefaultsKey = "accessToken"
  var accessToken : String?
  var imageQueue = NSOperationQueue()
  
  
  init() {
    let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: configuration)
    //set up a way to store the token to user defaults so we only do the authentication once
    if let userDefaultToken = NSUserDefaults.standardUserDefaults().objectForKey(accessTokenUserDefaultsKey) as? String {
      self.accessToken = userDefaultToken
    }
    
  }
  
  func fetchAccessToken() {
    let url = NSURL(string: "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo")
    //redirects user to the service provider by opening GitHub
    UIApplication.sharedApplication().openURL(url!)
  }
  
  
  
  func handleCallBackURL(url: NSURL) {
    let code = url.query?.componentsSeparatedByString("=").last
    println(code)
    let oauthURL = NSURL(string: "https://github.com/login/oauth/access_token?client_id=\(self.clientID)&client_secret=\(self.clientSecret)&code=\(code!)")
    let oauthRequest = NSMutableURLRequest(URL: oauthURL!)
    oauthRequest.HTTPMethod = "POST"
    
    let dataTask = self.urlSession.dataTaskWithRequest(oauthRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {

          case 200...299:
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            let tokenResponseFirst = tokenResponse?.componentsSeparatedByString("=")[1] as String
            let accessToken = tokenResponseFirst.componentsSeparatedByString("&").first
            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: self.accessTokenUserDefaultsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
          case 400...499:
            println("An error has happened. Status code: \(httpResponse.statusCode)")
          default:
            println("Default case fired")
          }}
      else {
        
        }}
    })
    dataTask.resume()
    
    
  }
  
  func fetchRepositoriesForSearch(searchTerm: String, callback : ([Repository], Int) -> (Void)) {
    
    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    let repoDataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
    
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
        
        if let repoDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
          let repoArray = repoDictionary["items"] as [NSObject]
          var localRepos = [Repository]()
          for item in repoArray {
            var repo = item as [String: AnyObject]
            var ownerInfo = repo["owner"] as [String: AnyObject]
            var repoInfo = Repository(name: repo["name"]! as String, author: ownerInfo["login"]! as String, url: repo["html_url"]! as String)
            localRepos.append(repoInfo)
          }
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            callback(localRepos, httpResponse.statusCode)
          })
        }
          case 400...499:
          println("An error has happened. Status code: \(httpResponse.statusCode)")
          default:
          println("Default case fired. Status code: \(httpResponse.statusCode)")
          }}}
      else {
        println("Meow mix: something went wrong!")
      }
      })
    repoDataTask.resume()
    
  }
  
  
  func fetchUsersForSearch(searchTerm: String, callback : ([User], Int) -> (Void)) {
    
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    let userDataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
          if let itemArray = jsonDictionary["items"] as? [[String : AnyObject]] {
            var localUsers = [User]()
            for item in itemArray {
              var user = User(jsonDictionary: item)
              localUsers.append(user)
              
            }
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            callback(localUsers, httpResponse.statusCode)
          })
          }}
          case 400...499:
          println("An error has happened. Status code: \(httpResponse.statusCode)")
          default:
          println("Default case fired. Status code: \(httpResponse.statusCode)")
          }}}
    
      else {
        println("Meow mix: something went wrong!")
      }})
    userDataTask.resume()
  }
  
  func fetchUserPhoto(url: String, callback: (UIImage) -> (Void)) {
    var url = NSURL(string: url)
    
    self.imageQueue.addOperationWithBlock { () -> Void in
      let imageData = NSData(contentsOfURL: url!)
      let image = UIImage(data: imageData!)
      
      NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
        callback(image!)
      }
    }
    
  }

  func fetchSingleUser(userName: String, callback : ([String : AnyObject], Int) -> (Void)) {
    
  let url = NSURL(string: "https://api.github.com/users/\(userName)")
  let request = NSMutableURLRequest(URL: url!)
  request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
 let userDataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in

  if error == nil {
 if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
              //println(jsonDictionary)
              for (key, value) in jsonDictionary {
                println("\(key):\(value)")
              }
             var userDetail = jsonDictionary
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(userDetail, httpResponse.statusCode)
                })
            }
          case 400...499:
            println("An error has happened. Status code: \(httpResponse.statusCode)")
          default:
            println("Default case fired. Status code: \(httpResponse.statusCode)")
          }}}
  
      else {
        println("Meow mix: something went wrong!")
      }})
    userDataTask.resume()
  }}

//
//  RepoDetailViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/22/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit
import WebKit

class RepoDetailViewController: UIViewController {

  let webView = WKWebView()
  var url : String!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.webView.frame = self.view.frame
      self.view.addSubview(webView)

      let request = NSURLRequest(URL: NSURL(string: self.url)!)
      self.webView.loadRequest(request)
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

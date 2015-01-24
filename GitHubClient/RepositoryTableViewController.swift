//
//  RepositoryTableViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/19/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit

class RepositoryTableViewController: UITableViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var repoSearch: UISearchBar!
  
  @IBOutlet var repoResults: UITableView!

  let networkController = NetworkController()
  var repositories = [Repository]()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.repoResults.dataSource = self
      self.repoResults.delegate = self
      self.repoSearch.delegate = self
    
      
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
  
  
    func searchBarSearchButtonClicked(repoSearch: UISearchBar) {
    performSearch(repoSearch.text)
    repoSearch.resignFirstResponder()
  }
  
  func performSearch(searchTerm: String) {
    self.networkController.fetchRepositoriesForSearch(searchTerm, callback: { (repos, error) -> (Void) in
      self.repositories = repos
      self.repoResults.reloadData()
    })
  }
  
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validateEntry()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repositories.count
  }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as RepoCell
      var repo = self.repositories[indexPath.row]
      cell.name.text = repo.name
      cell.author.text = repo.author
      
      return cell
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_REPO" {
      let destinationVC = segue.destinationViewController as RepoDetailViewController
      let selectedIndexPath = self.repoResults.indexPathForSelectedRow()! as NSIndexPath
      destinationVC.url = self.repositories[selectedIndexPath.row].url
      
    }
  }
  

  
  

}

//
//  UserCollectionViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/21/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var userSearchBar: UISearchBar!
  @IBOutlet weak var userCollection: UICollectionView!
  
  var networkController = NetworkController()
  var users = [User]()
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    self.userSearchBar.delegate = self
    self.userCollection.dataSource = self
    self.userCollection.delegate = self
    self.userCollection.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    self.view.addSubview(userCollection)
    self.navigationController?.delegate = self
    
    }

  func searchBarSearchButtonClicked(userSearchBar: UISearchBar) {
    performSearch(userSearchBar.text)
    userSearchBar.resignFirstResponder()
  }
  
  
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    return text.validateEntry()
  }
  

  
  
  
  func performSearch(searchTerm: String) {
    self.networkController.fetchUsersForSearch(searchTerm, callback: { (users, error) -> (Void) in
      self.users = users
      self.userCollection.reloadData()
    })
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.users.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    
    cell.userPhoto.image = nil
    var user = self.users[indexPath.row]
    
    if !user.userName.isEmpty {
      cell.userName.text = user.userName
    }
    
    if user.userPhoto == nil {
    self.networkController.fetchUserPhoto(user.userPhotoURL, callback: { (photo) -> (Void) in
      cell.userPhoto.image = photo
      user.userPhoto = photo
      self.users[indexPath.row] = user
        })
    }
    else {
      cell.userPhoto.image = user.userPhoto
    }
    
    return cell
  }
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserDetailViewController {
      return ToUserDetailViewController()
    }
    return nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "DETAIL_SEGUE" {
      let destinationVC = segue.destinationViewController as UserDetailViewController
      let selectedIndextPath = self.userCollection.indexPathsForSelectedItems().first as NSIndexPath
      destinationVC.selectedUser = self.users[selectedIndextPath.row]
      
    }
  }
    
}

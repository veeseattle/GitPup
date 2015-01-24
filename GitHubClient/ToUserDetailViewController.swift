//
//  ToUserDetailViewController.swift
//  GitHubClient
//
//  Created by Vania Kurniawati on 1/22/15.
//  Copyright (c) 2015 Vania Kurniawati. All rights reserved.
//

import UIKit

class ToUserDetailViewController: NSObject, UIViewControllerAnimatedTransitioning {
  
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
   
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    
    let containerView = transitionContext.containerView()
    
    //pass selectedIndexPath
    let selectedIndexPath = fromVC.userCollection.indexPathsForSelectedItems().first as NSIndexPath
    let cell = fromVC.userCollection.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    let copiedCell = cell.userPhoto.snapshotViewAfterScreenUpdates(false)
    copiedCell.frame = containerView.convertRect(cell.userPhoto.frame, fromView: cell.userPhoto.superview)
    
    //get the to screen
    toVC.view.alpha = 0
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(copiedCell)
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: nil, animations: { () -> Void in
      cell.userPhoto.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
      cell.layer.borderWidth = 2
      cell.layer.borderColor = UIColor.greenColor().CGColor
    }) { (finished) -> Void in
      
    
    UIView.animateWithDuration(duration * 0.5, animations: { () -> Void in
      toVC.view.alpha = 1.0
      let frame = containerView.convertRect(toVC.userPhoto.frame, fromView: toVC.view)
      copiedCell.frame = frame
      
      }) { (finished) -> Void in
        
        toVC.userPhoto.hidden = false
        cell.userPhoto.hidden = false
        copiedCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
    }

    
  }
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.5
  }
}

//
//  CenterViewController.swift
//  SplitViewController-iOS9
//
//  Created by Alex Zimin on 02/10/15.
//  Copyright © 2015 Alexander Zimin. All rights reserved.
//

import UIKit
import Alamofire

var globalId = 0

class CenterViewController: UIViewController {
  
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var id = 0
    var numberOfCells = 50
    
    override func viewDidLoad() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "close")
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "open")
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
    
        newTitle.text = newsTitle
        id = globalId
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/NewsItemWatchCounter", parameters: ["id": "\(id)"])
    }
    
    func open() {
        az_splitController?.openSide()
    }
    
    func close() {
        az_splitController?.closeSide()
    }
}


extension CenterViewController {
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    let firstCell = collectionView?.visibleCells().first ?? UICollectionViewCell()
    guard let index = collectionView?.indexPathForCell(firstCell) else {
      return
    }
    
    coordinator.animateAlongsideTransition({ (context) -> Void in
      self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
      }, completion: nil)
  }
}

// MARK: - UICollectionViewDataSource

extension CenterViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfCells
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
    
    (cell.contentView.viewWithTag(20) as? UILabel)?.text = "\(indexPath.section)-\(indexPath.row)"
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    numberOfCells--;
    collectionView.deleteItemsAtIndexPaths([indexPath])
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CenterViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
}


//
//  LeftViewController.swift
//  SplitViewController-iOS9
//
//  Created by Alex Zimin on 02/10/15.
//  Copyright © 2015 Alexander Zimin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import CoreData
import SwiftyJSON

var newsTitle = ""

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var loadMoreStatus = false
    var newsArray: [AnyObject] = []
    var countRow = 0
    var currentPage = 1
    var text = "Habrapost"
    var refreshControl:UIRefreshControl!

    // MARK: - Orientation
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewsTableViewCell
        newsTitle = cell.newsText
        globalId = cell.newsId
        
        az_splitController?.mainController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Center") as! UINavigationController)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            az_splitController?.toggleSide()
        }

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell") as! NewsTableViewCell
        if countRow == 0 {
            cell.titleLabel?.text = ""
        } else {
            let currentNew = newsArray[indexPath.row]
            cell.titleLabel?.text = currentNew["title"] as? String
            cell.shortDescriptionLabel?.text = currentNew["description"] as? String
            cell.newImage?.image = UIImage(named: "newsImage")
            cell.newsId = currentNew["id"] as! Int
            cell.newsText = (currentNew["text"] as? String)!
            cell.newImage?.layer.cornerRadius = 32
            cell.newImage?.layer.masksToBounds = true
        }
        return cell
    }

    func refresh(sender:AnyObject) {
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.countRow = 0
            self.currentPage = 1
            self.newsArray = []
            Alamofire.request(.GET, "http://lyceum.styleru.net/app/api/NewsGet", parameters: ["position": self.currentPage]) .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON["error_code"] as! String == "00" {
                        let temp = JSON["news"]
                        let number = JSON["amount"] as! Int
                        self.countRow += number
                        self.currentPage += 1
                        for i in 0..<number {
                            self.newsArray.append(temp!![i])
                        }
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        refreshEnd(0)
                    }
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.tableView.tableFooterView = viewMore
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        self.refresh(self)
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            az_splitController?.toggleSide()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            loadMore()
        }
    }
    
    func loadMore() {
        if ( !loadMoreStatus ) {
            self.loadMoreStatus = true
            self.activityIndicator.startAnimating()
            self.tableView.tableFooterView!.hidden = false
            loadMoreBegin("Load more",
                loadMoreEnd: {(x:Int) -> () in
                    self.tableView.reloadData()
                    self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.GET, "http://lyceum.styleru.net/app/api/NewsGet", parameters: ["position": self.currentPage]) .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON["error_code"] as! String == "00" {
                        let temp = JSON["news"]
                        let number = JSON["amount"] as! Int
                        self.countRow += number
                        self.currentPage += 1
                        for i in 0..<number {
                            self.newsArray.append(temp!![i])
                        }
                    }

                    dispatch_async(dispatch_get_main_queue()) {
                        loadMoreEnd(0)
                    }
                }
            }
        }
    }
}

extension LeftViewController {
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}



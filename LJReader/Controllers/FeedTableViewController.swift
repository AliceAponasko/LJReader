//
//  FeedTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var articles = [FeedEntry]()
    
    var dateFormatter = NSDateFormatter()
    let timeZone = NSTimeZone(abbreviation: "GMT")
    
    let ljClient = LJClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.timeZone = timeZone
        
        tableView.estimatedRowHeight = FeedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshFeed:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        refreshFeed(self)
    }
    
    // MARK: Actions
    
    func refreshFeed(sender: AnyObject?) {
        var feedResult = [FeedEntry]()
        articles.removeAll()
        
        let authors = [Const.LJAuthorURL.Glagolas, Const.LJAuthorURL.Evolutio, Const.LJAuthorURL.Tema]
        for author in authors {
            ljClient.get(author, parameters: nil) { (success, result, error) -> () in
                if success {
                    guard let result = result else {
                        return
                    }
                    
                    feedResult += result
                    self.updateWithresult(feedResult)
                } else {
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    func updateWithresult(result: [FeedEntry]) {
        articles = result
        articles.sortInPlace { (first, second) -> Bool in
            let firstDate = self.dateFormatter.dateFromString(first.pubDate)
            let secondDate = self.dateFormatter.dateFromString(second.pubDate)
            if firstDate < secondDate {
                return true
            } else {
                return false
            }
        }
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedCellID, forIndexPath: indexPath) as! FeedCell

        let article = articles[indexPath.row]
        cell.nameTitleLabel.text = article.author
        cell.nameTitleLabel.preferredMaxLayoutWidth = tableView.frame.width - 30
        cell.nameTitleLabel.sizeToFit()
        cell.articleTitleLabel.text = article.title
        cell.articleTitleLabel.preferredMaxLayoutWidth = tableView.frame.width - 30
        cell.articleTitleLabel.sizeToFit()

        return cell
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sender = sender as? FeedCell {
            guard let articleViewController = segue.destinationViewController as? ArticleViewController else {
                return
            }
            
            guard let indexPath = tableView.indexPathForCell(sender) else {
                return
            }
            
            articleViewController.article = articles[indexPath.row]
        }
    }
}

//
//  FeedTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit
import AlamofireImage

class FeedTableViewController: UITableViewController {
    
    var articles = [FeedEntry]()
    var authors = [String]()
    
    var dateFormatter = NSDateFormatter()
    var cellDateFormatter = NSDateFormatter()
    let timeZone = NSTimeZone(abbreviation: "GMT")
    
    let ljClient = LJClient.sharedInstance
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.timeZone = timeZone
        
        cellDateFormatter.dateStyle = .ShortStyle
        cellDateFormatter.timeStyle = .ShortStyle
        cellDateFormatter.doesRelativeDateFormatting = true
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refreshFeed:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let storedAuthors = userDefaults.authors() else {
            authors.removeAll()
            refreshFeed(self)
            return
        }
        
        if storedAuthors.count != authors.count {
            refreshFeed(self)
        }
        
        authors = storedAuthors
    }
    
    // MARK: Actions
    
    func refreshFeed(sender: AnyObject?) {
        var feedResult = [FeedEntry]()
        articles.removeAll()
        
        guard let authors = userDefaults.authors() else {
            tableView.reloadData()
            refreshControl?.endRefreshing()
            showEmptyResultsView()
            return
        }
        
        for author in authors {
            ljClient.get(author, parameters: nil) { (success, result, error) -> () in
                if success {
                    guard let result = result else {
                        return
                    }
                    
                    feedResult += result
                    self.updateWithresult(feedResult)
                    self.hideEmptyResultsView()
                } else {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                    self.showEmptyResultsView()
                }
            }
        }
    }
    
    func updateWithresult(result: [FeedEntry]) {
        articles = result
        articles.sortInPlace { (first, second) -> Bool in
            let firstDate = self.dateFormatter.dateFromString(first.pubDate)
            let secondDate = self.dateFormatter.dateFromString(second.pubDate)
            if firstDate > secondDate {
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
        let pubDate = dateFormatter.dateFromString(article.pubDate)!
        cell.pubDateLabel.text = cellDateFormatter.stringFromDate(pubDate)
        cell.nameTitleLabel.text = article.author
        cell.nameTitleLabel.preferredMaxLayoutWidth = tableView.frame.width - 30
        cell.nameTitleLabel.sizeToFit()
        cell.articleTitleLabel.text = article.title
        cell.articleTitleLabel.preferredMaxLayoutWidth = tableView.frame.width - 30
        cell.articleTitleLabel.sizeToFit()
        cell.avatarImageView.layer.cornerRadius = 3.0
        cell.avatarImageView.layer.masksToBounds = true
        cell.avatarImageView.af_setImageWithURL(NSURL(string: article.imageURL)!)

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let text = articles[indexPath.row].title
        let messageTextWidth: CGFloat = CGRectGetWidth(tableView.frame) - FeedCellPadding
        let attributes: NSDictionary = [ NSFontAttributeName: UIFont.systemFontOfSize(20.0) ]
        let preferredBounds = text.boundingRectWithSize(CGSizeMake(messageTextWidth, 0),
            options: .UsesLineFragmentOrigin, attributes: attributes as? [String : AnyObject], context: nil)
        let calculatedHeight = FeedCellHeight - FeedCellMinTextHeight + CGRectGetHeight(preferredBounds)
        return max(calculatedHeight, FeedCellHeight)
    }
    
    // MARK: Views
    
    func showEmptyResultsView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        let emptyResultsLabel = UILabel()
        emptyResultsLabel.text = "Your feed is currently empty."
        emptyResultsLabel.textAlignment = .Center
        emptyResultsLabel.numberOfLines = 0
        footerView.addSubview(emptyResultsLabel)
        emptyResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        footerView.addConstraint(NSLayoutConstraint(item: emptyResultsLabel, attribute: .Top, relatedBy: .Equal,
            toItem: footerView, attribute: .Top, multiplier: 1, constant: 0))
        footerView.addConstraint(NSLayoutConstraint(item: emptyResultsLabel, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: footerView.frame.height))
        footerView.addConstraint(NSLayoutConstraint(item: emptyResultsLabel, attribute: .Right, relatedBy: .Equal,
            toItem: footerView, attribute: .Right, multiplier: 1, constant: 0))
        footerView.addConstraint(NSLayoutConstraint(item: emptyResultsLabel, attribute: .Left, relatedBy: .Equal,
            toItem: footerView, attribute: .Left, multiplier: 1, constant: 0))
        tableView.tableFooterView = footerView
    }
    
    func hideEmptyResultsView() {
        tableView.tableFooterView = nil
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

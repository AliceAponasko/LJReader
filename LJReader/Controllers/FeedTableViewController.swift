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

    // MARK: Properties
    
    let ljClient = LJClient.sharedInstance
    let defaults = NSUserDefaults.standardUserDefaults()

    // MARK: Delegate

    private lazy var feedDelegate: FeedTableDelegate = {
        return FeedTableDelegate(
            dataSource: self.feedDataSource)
    }()

    private lazy var feedDataSource: FeedTableDataSource = {
        return FeedTableDataSource()
    }()

    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(
            self,
            action: #selector(refreshFeed(_:)),
            forControlEvents: .ValueChanged)

        tableView.addSubview(refreshControl!)

        tableView.delegate = feedDelegate
        tableView.dataSource = feedDataSource
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let storedAuthors = defaults.authors() else {
            feedDataSource.authors.removeAll()
            refreshFeed(self)
            return
        }
        
        if storedAuthors.count != feedDataSource.authors.count {
            refreshFeed(self)
        }
        
        feedDataSource.authors = storedAuthors
    }

    // MARK: Actions
    
    func refreshFeed(sender: AnyObject?) {
        var feedResult = [FeedEntry]()
        feedDataSource.articles.removeAll()

        guard let authors = defaults.authors() else {
            tableView.reloadData()
            refreshControl?.endRefreshing()
            showEmptyResultsView()
            return
        }
        
        for author in authors {
            ljClient.get(author, parameters: nil) {
                [unowned self] success, result, error in

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

        feedDataSource.articles = result
        feedDataSource.articles.sortInPlace {
            (first, second) -> Bool in

            let firstDate =
                self.feedDataSource.dateFormatter.dateFromString(first.pubDate)
            let secondDate =
                self.feedDataSource.dateFormatter.dateFromString(second.pubDate)

            return firstDate > secondDate
        }
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    // MARK: Views
    
    func showEmptyResultsView() {
        tableView.tableFooterView = emptyResultsView("Your feed is currently empty.")
    }
    
    func hideEmptyResultsView() {
        tableView.tableFooterView = nil
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(
        segue: UIStoryboardSegue,
        sender: AnyObject?) {

        if let sender = sender as? FeedCell {
            guard let articleViewController =
                segue.destinationViewController as? ArticleViewController else {
                return
            }
            
            guard let indexPath = tableView.indexPathForCell(sender) else {
                return
            }
            
            articleViewController.article = feedDataSource.articles[indexPath.row]
        }
    }
}

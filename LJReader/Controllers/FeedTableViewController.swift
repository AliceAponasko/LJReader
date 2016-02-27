//
//  FeedTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    var articles = [FeedEntry]()
    
    let ljClient = LJClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = FeedCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ljClient.get(Const.LJAuthorURL.Glagolas, parameters: nil) { (success, result, error) -> () in
            if success {
                guard let result = result else {
                    return
                }
                
                self.articles = result
                self.tableView.reloadData()
            }
        }
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

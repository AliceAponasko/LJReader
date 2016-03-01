//
//  ReadingListTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/27/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class ReadingListTableViewController: UITableViewController {
    
    var authors = [String]()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authors = userDefaults.authors() {
            self.authors = authors
        } else {
            showEmptyResultsView()
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AuthorCell", forIndexPath: indexPath)

        cell.textLabel?.text = authors[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let author = authors.removeAtIndex(indexPath.row)
            userDefaults.removeAuthor(author)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: Views
    
    func showEmptyResultsView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        
        let emptyResultsLabel = UILabel()
        emptyResultsLabel.text = "Your reading list is currently empty."
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
}

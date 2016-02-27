//
//  ReadingListTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/27/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class ReadingListTableViewController: UITableViewController {
    
    var authors = [Const.LJAuthorURL.Glagolas, Const.LJAuthorURL.Evolutio, Const.LJAuthorURL.Tema]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

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
            authors.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

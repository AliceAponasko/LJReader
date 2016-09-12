//
//  ReadingListTableDataSource.swift
//  LJReader
//
//  Created by Alice Aponasko on 9/12/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class ReadingListTableDataSource: NSObject, UITableViewDataSource {

    var authors = [String]()

    var defaults: NSUserDefaults?

    convenience init(defaults: NSUserDefaults) {
        self.init()

        self.defaults = defaults
    }

    private override init() {
        super.init()
    }

    func numberOfSectionsInTableView(
        tableView: UITableView) -> Int {

        return 1
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {

        return authors.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(
            "AuthorCell",
            forIndexPath: indexPath)

        cell.textLabel?.text = authors[indexPath.row]

        return cell
    }

    func tableView(
        tableView: UITableView,
        canEditRowAtIndexPath
        indexPath: NSIndexPath) -> Bool {

        return true
    }

    func tableView(
        tableView: UITableView,
        commitEditingStyle
        editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {
            let author = authors.removeAtIndex(indexPath.row)
            defaults?.removeAuthor(author)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

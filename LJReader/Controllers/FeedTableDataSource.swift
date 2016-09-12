//
//  FeedTableDataSource.swift
//  LJReader
//
//  Created by Alice Aponasko on 9/11/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class FeedTableDataSource: NSObject, UITableViewDataSource {

    let timeZone = NSTimeZone(abbreviation: "GMT")

    var articles = [FeedEntry]()
    var authors = [String]()
    var dateFormatter = NSDateFormatter()

    override init() {
        super.init()

        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.timeZone = timeZone
    }

    func numberOfSectionsInTableView(
        tableView: UITableView) -> Int {

        return 1
    }

    func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {

        return articles.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: FeedCell

        if let feedCell = tableView.dequeueReusableCellWithIdentifier(
            FeedCell.cellID) as? FeedCell {

             cell = feedCell
        } else {
            tableView.registerClass(
                FeedCell.self,
                forCellReuseIdentifier: FeedCell.cellID)

            cell = FeedCell()
        }

        let article = articles[indexPath.row]
        let pubDate = dateFormatter.dateFromString(article.pubDate)!
        
        cell.setFromArticle(
            article,
            pubDate: pubDate,
            width: tableView.frame.width)

        return cell
    }
}

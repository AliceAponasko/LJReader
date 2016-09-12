//
//  FeedTableDelegate.swift
//  LJReader
//
//  Created by Alice Aponasko on 9/11/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class FeedTableDelegate: NSObject, UITableViewDelegate {

    var dataSource: FeedTableDataSource?

    convenience init(dataSource: FeedTableDataSource) {
        self.init()

        self.dataSource = dataSource
    }

    private override init() {
        super.init()
    }

    func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        guard let dataSource = dataSource else {
            return FeedCell.cellHeight
        }

        let text = dataSource.articles[indexPath.row].title

        let messageTextWidth: CGFloat = CGRectGetWidth(tableView.frame) - FeedCell.padding

        let attributes: NSDictionary = [ NSFontAttributeName: UIFont.systemFontOfSize(20.0) ]

        let preferredBounds = text.boundingRectWithSize(
            CGSize(
                width: messageTextWidth,
                height: 0),
            options: .UsesLineFragmentOrigin,
            attributes: attributes as? [String : AnyObject],
            context: nil)

        let calculatedHeight =
            FeedCell.cellHeight -
            FeedCell.minTextHeight +
            CGRectGetHeight(preferredBounds)

        return max(calculatedHeight, FeedCell.cellHeight)
    }
}

//
//  FeedCell.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    static let cellID = "FeedCell"
    static let cellHeight: CGFloat = 75.0
    static let minTextHeight: CGFloat = 20.0
    static let padding: CGFloat = 120.0

    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!

    private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

    // MARK: Helpers

    func setFromArticle(
        article: FeedEntry,
        pubDate: NSDate,
        width: CGFloat) {

        pubDateLabel.text = dateFormatter.stringFromDate(pubDate)

        nameTitleLabel.text = article.author
        nameTitleLabel.preferredMaxLayoutWidth = width - 30
        nameTitleLabel.sizeToFit()

        articleTitleLabel.text = article.title
        articleTitleLabel.preferredMaxLayoutWidth = width - 30
        articleTitleLabel.sizeToFit()

        avatarImageView.layer.cornerRadius = 3.0
        avatarImageView.layer.masksToBounds = true
        avatarImageView.af_setImageWithURL(NSURL(string: article.imageURL)!)

    }
}

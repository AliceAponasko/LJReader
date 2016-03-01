//
//  FeedCell.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

let FeedCellID = "FeedCell"
let FeedCellHeight: CGFloat = 75.0
let FeedCellMinTextHeight: CGFloat = 20.0
let FeedCellPadding: CGFloat = 120.0

class FeedCell: UITableViewCell {
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
}

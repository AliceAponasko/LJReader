//
//  ArticleViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/26/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleWebView: UIWebView!

    // MARK: Properties
    
    var article: FeedEntry?

    // MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = self.article {
            title = article.author
            nameLabel.text = article.title
            nameLabel.preferredMaxLayoutWidth = view.frame.width
            nameLabel.sizeToFit()
            articleWebView.loadHTMLString(
                article.description,
                baseURL: nil)
        }
    }
}

// MARK: - UIWebViewDelegate

extension ArticleViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        articleWebView.contentMode = .ScaleAspectFit
    }
}

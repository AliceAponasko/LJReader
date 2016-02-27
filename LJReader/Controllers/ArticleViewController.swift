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
    
    var article: FeedEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = self.article {
            title = article.author
            nameLabel.text = article.title
            nameLabel.preferredMaxLayoutWidth = view.frame.width
            nameLabel.sizeToFit()
            articleWebView.loadHTMLString(article.description, baseURL: nil)
        }
    }
}

extension ArticleViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        articleWebView.contentMode = .ScaleAspectFit
    }
}
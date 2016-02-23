//
//  HomeTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/14/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    var articles = [FeedEntry]()
    var articleHeights = [CGFloat]()
    
    let ljClient = LJClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ljClient.get(Const.LJAuthorURL.Glagolas, parameters: nil) { (success, resultArray, error) -> () in
            if success {
                guard let result = resultArray else {
                    return
                }
                
                self.articles = result
                for _ in 0..<self.articles.count {
                    self.articleHeights.append(MainCellHeight)
                }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(MainCellID, forIndexPath: indexPath) as! MainCell

        let article = articles[indexPath.row]
        cell.nameTitleLabel.text = "\(article.author) - \(article.title)"
        cell.articleTextWebView.tag = indexPath.row
        cell.articleTextWebView.delegate = self
        cell.articleTextWebView.loadHTMLString(article.description, baseURL: nil)

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return articleHeights[indexPath.row]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTableViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        if (articleHeights[webView.tag] != MainCellHeight) {
            return
        }
        
        articleHeights[webView.tag] = webView.scrollView.contentSize.height
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: webView.tag, inSection: 0)], withRowAnimation: .Automatic)
    }
}

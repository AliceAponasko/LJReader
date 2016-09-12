//
//  ReadingListTableViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/27/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class ReadingListTableViewController: UITableViewController {

    // MARK: Properties
    
    let defaults = NSUserDefaults.standardUserDefaults()

    private lazy var readingDataSource: ReadingListTableDataSource = {
        return ReadingListTableDataSource(defaults: self.defaults)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = readingDataSource
        
        if let authors = defaults.authors() {
            self.readingDataSource.authors = authors
        } else {
            showEmptyResultsView()
        }
    }
    
    // MARK: Views
    
    func showEmptyResultsView() {
        tableView.tableFooterView = emptyResultsView("Your reading list is currently empty.")
    }
    
    func hideEmptyResultsView() {
        tableView.tableFooterView = nil
    }
}

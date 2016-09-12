//
//  UIViewControllerExtension.swift
//  LJReader
//
//  Created by Alice Aponasko on 9/11/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

extension UIViewController {

    func emptyResultsView(title: String) -> UIView {

        let emptyView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 200))

        let emptyResultsLabel = UILabel()
        emptyResultsLabel.text = title
        emptyResultsLabel.textAlignment = .Center
        emptyResultsLabel.numberOfLines = 0
        emptyView.addSubview(emptyResultsLabel)

        emptyResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyView.addConstraint(NSLayoutConstraint(
            item: emptyResultsLabel,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: emptyView,
            attribute: .Top,
            multiplier: 1,
            constant: 0))
        emptyView.addConstraint(NSLayoutConstraint(
            item: emptyResultsLabel,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: emptyView.frame.height))
        emptyView.addConstraint(NSLayoutConstraint(
            item: emptyResultsLabel,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: emptyView,
            attribute: .Right,
            multiplier: 1,
            constant: 0))
        emptyView.addConstraint(NSLayoutConstraint(
            item: emptyResultsLabel,
            attribute: .Left,
            relatedBy: .Equal,
            toItem: emptyView,
            attribute: .Left,
            multiplier: 1,
            constant: 0))

        return emptyView
    }
}

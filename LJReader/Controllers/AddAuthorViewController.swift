//
//  AddAuthorViewController.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/29/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

class AddAuthorViewController: UIViewController {

    @IBOutlet weak var addAuthorTextField: UITextField!

    // MARK: Properties
    
    var loadingOverlayView: UIView!
    var loadingActivityIndicator: UIActivityIndicatorView!
    
    let ljClient = LJClient.sharedInstance
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addAuthorTextField.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    @IBAction func addAuthorButtonTapped(sender: AnyObject) {
        guard let author = addAuthorTextField.text else {
            return
        }
        
        if author.isEmpty {
            return
        }
        
        showLoadingScreen()
        addAuthorTextField.resignFirstResponder()
        ljClient.get(author, parameters: nil) {
            [unowned self] success, _, _ in

            if success {
                self.defaults.addAuthor(author)
                self.showSuccessAlertWithTitle()
            } else {
                self.showFailureAlertWithTitle()
            }
        }
    }
    
    // MARK: Loading
    
    func showLoadingScreen() {
        loadingOverlayView = UIView(frame: view.frame)
        loadingOverlayView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        loadingActivityIndicator = UIActivityIndicatorView(
            activityIndicatorStyle: .WhiteLarge)
        loadingActivityIndicator.center = view.center
        loadingActivityIndicator.startAnimating()
        
        view.addSubview(loadingOverlayView)
        view.addSubview(loadingActivityIndicator)
        
        view.userInteractionEnabled = false
    }
    
    func hideLoadingScreen() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.loadingOverlayView?.alpha = 0
            self.loadingActivityIndicator?.alpha = 0
            }) { isFinished in
                self.loadingOverlayView?.removeFromSuperview()
                self.loadingActivityIndicator?.removeFromSuperview()
                
                self.loadingActivityIndicator = nil
                self.loadingOverlayView = nil
        }
        
        view.userInteractionEnabled = true
    }
    
    // MARK: Alert
    
    func showSuccessAlertWithTitle() {
        let alertVC = UIAlertController(
            title: "YAY",
            message: "Author was added to your reading list. Enjoy! 🎉",
            preferredStyle: UIAlertControllerStyle.Alert)

        alertVC.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: {
                [unowned self] action in
                self.navigationController?.popViewControllerAnimated(true)
            }))

        presentViewController(
            alertVC,
            animated: true,
            completion: nil)

        hideLoadingScreen()
    }
    
    func showFailureAlertWithTitle() {
        let alertVC = UIAlertController(
            title: "Hmmm...",
            message: "Cannot find this author 😔\nCheck the spelling and try again.",
            preferredStyle: UIAlertControllerStyle.Alert)

        alertVC.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: {
                [unowned self] action in
                self.addAuthorTextField.becomeFirstResponder()
            }))

        presentViewController(
            alertVC,
            animated: true,
            completion: nil)

        hideLoadingScreen()
    }
}

// MARK: - UITextFieldDelegate

extension AddAuthorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        textField: UITextField) -> Bool {

        addAuthorButtonTapped(self)
        return true
    }
}

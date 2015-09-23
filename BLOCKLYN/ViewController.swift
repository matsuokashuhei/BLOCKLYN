//
//  ViewController.swift
//  BLOCKLYN
//
//  Created by matsuosh on 2015/09/23.
//  Copyright © 2015年 matsuosh. All rights reserved.
//

import UIKit
import SafariServices

import SABlurImageView

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: SABlurImageView! {
        didSet {
            backgroundImageView.addBlurEffect(25)
        }
    }
    @IBOutlet weak var goSettingsButton: UIButton! {
        didSet {
            goSettingsButton.addTarget(self, action: "goSettingsButtonTapped", forControlEvents: .TouchUpInside)
        }
    }
    /*
    @IBOutlet weak var label1: UILabel! {
        didSet {
            label1.text = NSLocalizedString("Tap Settings", comment: "Label1")
        }
    }
    @IBOutlet weak var label2: UILabel! {
        didSet {
            label2.text = NSLocalizedString("Tap Settings > Safari > Content Blockers\nAllow BLOCKLYN in the list of Content Blockers", comment: "Label2")
        }
    }
    */
    @IBOutlet weak var infoButton: UIButton! {
        didSet {
            infoButton.addTarget(self, action: "infoButtonTapped", forControlEvents: .TouchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SFContentBlockerManager.reloadContentBlockerWithIdentifier("org.matsuosh.BLOCKLYN.ContentBlocker") { (error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func goSettingsButtonTapped() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }

    func infoButtonTapped() {
        performSegueWithIdentifier("showInfo", sender: nil)
    }

}


//
//  AboutViewController.swift
//  BLOCKLYN
//
//  Created by matsuosh on 2015/09/23.
//  Copyright © 2015年 matsuosh. All rights reserved.
//

import UIKit

import SABlurImageView

class AboutViewController: UIViewController {

    /*
    @IBOutlet weak var backgroundImageView: SABlurImageView! {
        didSet {
            backgroundImageView.addBlurEffect(25)
        }
    }
    */

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView(frame: CGRectZero)
            tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: backgroundBlurView.effect as! UIBlurEffect)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "stopButtonTapped")
    }

    func stopButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AboutViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AboutCell", forIndexPath: indexPath) as! AboutCell
        switch indexPath.row {
        case 0:
            cell.aboutLabel.text = NSLocalizedString("99 OR MORE FILTERS", comment: "99 OR MORE FILTERS")
        case 1:
            cell.aboutLabel.text = NSLocalizedString("SHARE THIS APP", comment: "SHARE THIS APP")
        case 2:
            cell.aboutLabel.text = NSLocalizedString("RATE THIS APP", comment: "RATE THIS APP")
        default:
            break
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("showRules", sender: nil)
        case 1:
            let title = "BLOCKLYN - Yet another content blocker"
            let URL = NSURL(string: "http://itunes.apple.com/app/id1042412696?mt=8")!
            let controller = UIActivityViewController(activityItems: [title, URL], applicationActivities: nil)
            presentViewController(controller, animated: true, completion: nil)
        case 2:
            let URL = NSURL(string: "itms-apps://itunes.apple.com/app/id1042412696")!
            UIApplication.sharedApplication().openURL(URL)
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

class AboutCell: UITableViewCell {
    @IBOutlet weak var aboutLabel: UILabel!
}
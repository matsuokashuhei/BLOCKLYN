//
//  RulesViewController.swift
//  BLOCKLYN
//
//  Created by matsuosh on 2015/09/23.
//  Copyright © 2015年 matsuosh. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    /*
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchBar = searchController.searchBar
            definesPresentationContext = true
        }
        
    }
    */

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.sizeToFit()
            searchController.searchBar.searchBarStyle = .Minimal
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
            tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: backgroundBlurView.effect as! UIBlurEffect)
            definesPresentationContext = true
        }
    }

    var searchController: UISearchController!

    var rules = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchReults = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "stopButtonTapped")
        load()
    }

    
    /*
        let country: String = {
            guard let country = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String else {
                return "us"
            }
            if country == "jp" {
                return "jp"
            } else {
                return "us"
            }
        }()
        let attachment: NSItemProvider
        if country == "jp" {
            attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList_ja", withExtension: "json"))!
        } else {
            attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"))!
        }
    */

    func load() {
        guard
            let contentsURL = NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"),
            let data = NSData(contentsOfURL: contentsURL) else {
                print("blockerList.jsonの読み込みに失敗しました。")
            return
        }
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSArray
            if let items = JSON as? [NSDictionary] {
                rules = items.flatMap { item -> String? in
                    /*
                    guard
                        let trigger = item["trigger"] as? NSDictionary,
                        let urlFilter = trigger["url-filter"] as? String else {
                            return nil
                    }
                    return urlFilter
                    */
                    if let simpleAddress = item["simple-address"] as? String {
                        return simpleAddress
                    } else {
                        return nil
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func filterContentForSearchText(searchText: String) {
        searchReults = rules.filter { (rule) -> Bool in
            if let _ = rule.rangeOfString(searchText, options: .CaseInsensitiveSearch) {
                return true
            } else {
                return false
            }
        }
    }

    func stopButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - Table view data source
extension RulesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchReults.count
        } else {
            return rules.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RuleCell", forIndexPath: indexPath) as! RuleCell
        if searchController.active {
           cell.urlFilterLabel.text = searchReults[indexPath.row]
        } else {
            cell.urlFilterLabel.text = rules[indexPath.row]
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    /*
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        //headerView.frame = CGRectMake(tableView.bounds.origin.x, tableView.bounds.origin.y, headerView.frame.size.width, headerView.frame.size.height)
        headerView.frame = CGRect(origin: tableView.bounds.origin, size: headerView.bounds.size)
    }
    */
}

extension RulesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
        }
    }
}

class RuleCell: UITableViewCell {
    @IBOutlet weak var urlFilterLabel: UILabel!
}
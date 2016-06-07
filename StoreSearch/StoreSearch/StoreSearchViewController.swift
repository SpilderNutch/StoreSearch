//
//  ViewController.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/7.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class StoreSearchViewController: UIViewController {

    
    var searchResults = [String]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension StoreSearchViewController :UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("The search text is \(searchBar.text)")
        
        
        for i in 0...2{
            searchResults.append(String(format: "Fake Result %d for '%@'",i,searchBar.text!))
        }
        
        tableView.reloadData()
    }
}


extension StoreSearchViewController : UITableViewDelegate {
    
    
}

extension StoreSearchViewController : UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        
        var cell :UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel?.text = searchResults[indexPath.row]
        
        return cell
    }
    
}


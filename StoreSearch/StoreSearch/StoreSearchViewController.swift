//
//  ViewController.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/7.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class StoreSearchViewController: UIViewController {
    
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }

    
    var searchResults = [SearchResult]()
    
    var hadSearched = false
    
    var isLoading = false
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        //注册SearchCellNib
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        //注册NothingFoundCell
        let nothingCellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(nothingCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        //注册LoadingCell
        let loadingCellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(loadingCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        
        
        //给tableView定义高度为80。
        tableView.rowHeight = 80
        
        
        searchBar.becomeFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func urlWithSearchText(searchText :String)-> NSURL {
        
        //为链接加上可以允许的字符段。
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
        
        let url = NSURL(string: urlString)
        
        return url!
    }
    
    
    //链接请求
    func performStoreRequestWithURL(url:NSURL) -> String?{
        do {
            
            return try String(contentsOfURL: url,encoding :NSUTF8StringEncoding)
            
        } catch {
            print("Download Error:\(error)");
            return nil
        }
    }
    
    //Parse Json 串
    func parseJson(jsonString : String )->[String:AnyObject]? {
        
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
            else{return nil}
        
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        }catch{
            print("JSON Error: \(error)")
            return nil
        }
        
        
        
    }
    
    
    func showNetworkError(){
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func parseDictionary(dictionary :[String:AnyObject]) -> [SearchResult]? {
        
        guard let array = dictionary["results"] as? [[String:AnyObject]] else{
            print("Excepted 'results' arrry ")
            return nil
        }
        
        var searchResults = [SearchResult]()
        
        for resultDic in array
        {
            var searchResult : SearchResult?
            if let wrapperType = resultDic["wrapperType"] as? String {
                
                switch wrapperType {
                case "track":
                    searchResult = parseTrack(resultDic)
                default:
                    searchResult = parseTrack(resultDic)
                }
                
                
            }
            
            if let result = searchResult {
                searchResults.append(result)
            }
            
            
        }
        return searchResults
    }
    
    
    
    func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] == nil ? "" : dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkUrl60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkUrl100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] == nil ? "" : dictionary["trackViewUrl"]  as! String
        searchResult.kind = dictionary["kind"] == nil ? "" : dictionary["kind"]as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["trackPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    
    
    func kindForDisplay(kind :String) -> String {
        switch kind {
        case "album":
            return "Album"
        case "audiobook":
            return "Audio Book"
        case "book":
            return "Book"
        case "ebook":
            return "Ebook"
        case "featrue-movie":
            return "Movie"
        case "music-video":
            return "Music Video"
        case "podcast":
            return "Podcase"
        case "software":
            return "App"
        case "song":
            return "Song"
        case "tv-episode":
            return "TV Episode"
        default:
            return kind
        }
    }
    
}




extension StoreSearchViewController :UISearchBarDelegate {
    
    //将searchBar修饰更加好看
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("The search text is \(searchBar.text)")
        


        
        
        if !searchBar.text!.isEmpty{
            //设置serchBar作为FirstResponder,以便于隐藏键盘
            searchBar.resignFirstResponder();
            
 
            isLoading = true
            tableView.reloadData()
 
            hadSearched = true
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            
            dispatch_async(queue) {
                let url = self.urlWithSearchText(searchBar.text!)
                
                print(url)
                
                if let jsonString = self.performStoreRequestWithURL(url) {
                    print("Received JSON string '\(jsonString)'")
                    
                    if let dictionary = self.parseJson(jsonString){
                        
                        self.searchResults = self.parseDictionary(dictionary)!
                        
                        self.searchResults.sortInPlace({result1,result2 in return
                            result1.name.localizedStandardCompare(result2.name) == .OrderedAscending})
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.showNetworkError()
                }
            }
        }
 
    }
}



extension StoreSearchViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0  || isLoading {
            return nil
        }else{
            return indexPath
        }
    }
    
    
}

extension StoreSearchViewController : UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        }else if !hadSearched {
            return 0
        }else{
            if searchResults.count == 0 {
                return 1
            }else{
                return searchResults.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isLoading {
          let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell,forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }else if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            if searchResult.artistName.isEmpty  {
                cell.artistNameLabel.text = "Unknown"
            }else{
                cell.artistNameLabel.text = String(format: "%@ (%@)",searchResult.artistName,kindForDisplay(searchResult.kind) )
            }
            
            return cell
        }
    }
    
    
    
    
    
    /**
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    */
    
    
    
    
}


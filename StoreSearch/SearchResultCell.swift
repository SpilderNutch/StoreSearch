//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/7.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var downloadTask : NSURLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func confiureForSearchResult(searchResult : SearchResult)  {
        nameLabel.text = searchResult.name
        if searchResult.artistName.isEmpty  {
            artistNameLabel.text = "Unknown"
        }else{
            artistNameLabel.text = String(format: "%@ (%@)",searchResult.artistName,kindForDisplay(searchResult.kind) )
        }
        if let url = NSURL(string: searchResult.artworkUrl60){
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        
        nameLabel.text = nil
        artistNameLabel.text = nil
        artworkImageView.image = nil
    }
    
}

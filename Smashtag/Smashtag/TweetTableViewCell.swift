//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Alexandre THOMAS on 26/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {
        
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        if let tweet = self.tweet {
            
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " PHOTO"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                
                let qualityOfService = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qualityOfService, 0)) { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if imageData != nil {
                            self.tweetProfileImageView?.image = UIImage(data:imageData!)
                        } else {
                            self.tweetProfileImageView?.image = nil
                        }
                    }
                    
                }
            }
        }
    }
}

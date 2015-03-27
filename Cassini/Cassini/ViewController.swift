//
//  ViewController.swift
//  Cassini
//
//  Created by Alexandre THOMAS on 25/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if let destination = segue.destinationViewController as? ImageViewController {
                switch identifier {
                    case "google":
                        destination.imageURL = DemoURL.GoogleImageURL
                        destination.title = "Google"
                    case "bridge":
                        destination.imageURL = DemoURL.BridgeImageURL
                        destination.title = "Bridge"
                    case "saturn":
                        destination.imageURL = DemoURL.SaturnImageURL
                        destination.title = "Saturn"
                    default: break
                }
            }
        }
    }
}


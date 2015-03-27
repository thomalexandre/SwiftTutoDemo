//
//  DignosedHappynessController.swift
//  Psychologist
//
//  Created by Alexandre THOMAS on 23/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class DignosedHappynessController: HappinessViewController, UIPopoverPresentationControllerDelegate
{

    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory: [Int] {
        get {return defaults.objectForKey(History.DefaultKey) as? [Int] ?? [] }
        set { defaults.setObject(newValue, forKey:History.DefaultKey ) }
        
    }
            
    private struct History {
        static let SegueIdentifier = "historySegue"
        static let DefaultKey = "Diagnosed HappinerViewController.History"
    }
        
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("\(diagnosticHistory)")
        
        if let identifier = segue.identifier {
 
            switch identifier {
                case History.SegueIdentifier:
                    if let destination = segue.destinationViewController as? TextViewController {
                        if let ppc = destination.popoverPresentationController {
                            ppc.delegate = self
                        }
                        destination.text = "\(diagnosticHistory)"
                    }
            
                default: break
            }
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

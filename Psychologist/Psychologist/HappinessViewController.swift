//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Alexandre THOMAS on 19/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: faceView, action: "rotate:"))
            
        }
    }
    
    struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:break
        }
    }
    
    var happiness: Int = 75 { //0 = very sad, 100 = very happy
        didSet{
            happiness = min(max(happiness, 0), 100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double?
    {
        return Double(happiness - 50) / 50.0
    }
    
    func updateUI()
    {
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
    }
    
}

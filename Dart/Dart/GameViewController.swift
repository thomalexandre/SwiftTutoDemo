//
//  ViewController.swift
//  Dart
//
//  Created by Alexandre THOMAS on 24/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    
    var dartBrain = DartBrain()
    
    @IBOutlet weak var player1RoundResult: UITextField!
    @IBOutlet weak var player2RoundResult: UITextField!
    
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    
    @IBAction func roundResultValidate(sender: UITextField) {
        
        if sender.text == "" {
            return
        }
        
        
        if sender == player1RoundResult {
            dartBrain.player1HasRound(sender.text)
            player1RoundResult.text = ""
            player1RoundResult.enabled = false
            player2RoundResult.enabled = true
            player2RoundResult.becomeFirstResponder()
            player1Score.text = "\(dartBrain.player1Score)"
        } else if sender == player2RoundResult {
            dartBrain.player2HasRound(sender.text)
            player2RoundResult.text = ""
            player2RoundResult.enabled = false
            player1RoundResult.enabled = true
            player1RoundResult.becomeFirstResponder()
            player2Score.text = "\(dartBrain.player2Score)"
        }
        
        
        if dartBrain.player1Score == 0 {
            player1Score.textColor = UIColor.redColor()
            player1RoundResult.enabled = false
            player2RoundResult.enabled = false
        }
        if dartBrain.player2Score == 0 {
            player2Score.textColor = UIColor.redColor()
            player1RoundResult.enabled = false
            player2RoundResult.enabled = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        player1RoundResult.becomeFirstResponder()

    }
    
}


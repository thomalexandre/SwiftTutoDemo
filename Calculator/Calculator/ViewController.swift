//
//  ViewController.swift
//  Calculator
//
//  Created by Alexandre THOMAS on 09/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userHasEnterADFloatingPoint = false
    var operandStack = Array<Double>()
    var brain = CalculatorBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func digitDidPressSoAppendToDisplay(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            userIsInTheMiddleOfTypingANumber = true
            display.text = digit
        }
        
        displayHistory()
    }
    
    
    @IBAction func pointFloatingDidPress(sender: UIButton) {
        if !userHasEnterADFloatingPoint {
            if userIsInTheMiddleOfTypingANumber {
                 display.text = display.text! + "."
            } else {
                display.text = "0."
                userIsInTheMiddleOfTypingANumber = true
            }
            userHasEnterADFloatingPoint = true
        }
        
        displayHistory()
    }
    
    @IBAction func operatorDidPress(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enterDidPress()
        }

        // All of the 4 version below are valid in this case
        if let operation = sender.currentTitle {
            
            if let result = brain.performaOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        
            
            /*switch operation {
                // Swift is very typed, so we sont need to speciffy type at all
                //case "×" : performOperation({(op1, op2) in return op1 * op2})
                
                // we dont need the retun here, as the function has just 1 line of code so it automaticall returns it
                //case "+" : performOperation({(op1, op2) in  op1 + op2})
                
                // just remove the name of the variable, you can use $0, $1, $..... to each of the variable in the function
                //case "÷" : performOperation() { $1 / $0 }
                
                 
                // As no other, parameter to performOperation, we can just omit the () to have very small writting experience
                //case "−" : performOperation { $1 - $0 }
                
                
                case "×" : performOperation { $0 * $1 }
                case "÷" : performOperation { $1 / $0 }
                case "+" : performOperation { $0 + $1 }
                case "−" : performOperation { $1 - $0 }
                case "√" : performOperation { sqrt($0) }
                
                 default: break;
            }*/
            
            displayHistory()
            
        }
    }
    
    /*func performOperation(operation: (Double, Double) -> Double ) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enterDidPress()
        }
    }
    
    func performOperation(operation: (Double) -> Double ) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enterDidPress()
        }
    }*/
    
    @IBAction func enterDidPress() {
        userIsInTheMiddleOfTypingANumber = false
        userHasEnterADFloatingPoint = false
        
        //operandStack.append(displayValue)
        //println("operandStack =\(operandStack)")
        
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        displayHistory()
    }
    
    @IBAction func resetDidPress() {
        userIsInTheMiddleOfTypingANumber = false
        userHasEnterADFloatingPoint = false
        display.text = "0"
        history.text = ""
        brain.clear()
        
    }
    
    func  displayHistory(){
        if let historyText = brain.description {
            history.text = historyText
        }
    }
    
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            }
            else {
                return nil
            }
        }
        set {
            display.text = newValue == nil ? "" : "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}


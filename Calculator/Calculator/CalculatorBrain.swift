//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alexandre THOMAS on 10/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    
    private enum Op: Printable{
        case Operand(Double)
        case ConstantOperation(String, Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .ConstantOperation(let symbol, _) :
                        return symbol
                    case .UnaryOperation(let symbol, _) :
                        return symbol
                    case .BinaryOperation(let symbol, _) :
                        return symbol
                }
            }
        }
    }
    
    private var opsStack = [Op]()           // Array<Op>
    private var knowOps = [String:Op]()     //Dictionary<String, Op>
    
    var program: AnyObject { // guarantee to be a PropertyList
        get {
            /*var returnValue = Array<String>()
            for op in opsStack {
                returnValue.append(op.description)
            }
            return returnValue*/
            
            return opsStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOps = [Op]()
                for opSymbol in opSymbols {
                    if let op = knowOps[opSymbol] {
                        newOps.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOps.append(Op.Operand(operand))
                    }
                }
                opsStack = newOps
            }
        }
    }
    
    init() {
        
        func learnOp(op: Op) {
            knowOps[op.description] = op
        }

        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        
        knowOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knowOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knowOps["√"] = Op.UnaryOperation("√", sqrt )
        knowOps["sin"] = Op.UnaryOperation("sin", sin )
        knowOps["cos"] = Op.UnaryOperation("cos", cos )
        knowOps["π"] = Op.ConstantOperation("π", M_PI)
    }
    
    func pushOperand(operand: Double?) -> Double? {
        if operand != nil {
            opsStack.append(Op.Operand(operand!))
        }
        return evaluate()
    }
    
    func performaOperation(symbol: String) -> Double? {
        if let operation = knowOps[symbol] {
            opsStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opsStack)
        println("\(opsStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func clear() {
        opsStack.removeAll(keepCapacity: false)
    }
    
    var description: String? {
        let (result, _) = functionAsString(opsStack)
        return result
    }
    
    private func functionAsString(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
                
            case .ConstantOperation(let constant, _):
                return (constant, remainingOps)
                
            case .UnaryOperation(let operation, _): // Underscore is like "I dont care this value)
                let subFunction = functionAsString(remainingOps)
                if let subFunctionAsString = subFunction.result {
                    return (operation + "(" + subFunctionAsString + ")", remainingOps)
                }
                
            case .BinaryOperation(let operation, _):
                let subFunction1 = functionAsString(remainingOps)
                if let subFunctionAsString1 = subFunction1.result {
                    let subFunction2 = functionAsString(subFunction1.remainingOps)
                    if let subFunctionAsString2 = subFunction2.result {
                        return ("(" + subFunctionAsString2 + operation + subFunctionAsString1 + ")", subFunction2.remainingOps)
                    }
                }
                
            }
        }

        
        return (nil, ops)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                
                case .ConstantOperation(_, let constant):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operand * constant, operandEvaluation.remainingOps)
                    } else {
                        return (constant, operandEvaluation.remainingOps)
                    }
                
                
                case .UnaryOperation(_, let operation): // Underscore is like "I dont care this value)
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
            }
        }
        return (nil, ops)
    }
}

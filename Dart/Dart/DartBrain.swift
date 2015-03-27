//
//  DartBrain.swift
//  Dart
//
//  Created by Alexandre THOMAS on 24/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import Foundation

class DartBrain {
    
    var players: [Int] = [301, 301]
    
    var player1Score: Int {
        return players[0]
    }
    
    var player2Score: Int {
        return players[1]
    }
    
    func player1HasRound(roundResult: String) {
        playerHasRound(0, roundResult: roundResult)
    }
    
    func player2HasRound(roundResult: String) {
        playerHasRound(1, roundResult: roundResult)
    }
    
    private func playerHasRound(playerIndex: Int, roundResult: String) {
        
        var results = split(roundResult) {$0 == " "}
        
        println("User \(playerIndex+1)")
        
        for result in results {
            
            let charAtIndex = result[advance(result.startIndex, 0)]
            
            if let firstCharNumber = NSNumberFormatter().numberFromString(String(charAtIndex))  {
                if let throwResult = NSNumberFormatter().numberFromString(result)?.integerValue {
                    players[playerIndex] -= throwResult
                    println(" - \(throwResult)")
                }
            } else {
                let restNumber = result[Range(start: advance(result.startIndex, 1), end: advance(result.endIndex, 0))]
                if let throwResult = NSNumberFormatter().numberFromString(restNumber)?.integerValue {
                    switch charAtIndex {
                        case "t":
                            players[playerIndex] -= 3 * throwResult
                            println(" - triple \(throwResult)")
                        case "d":
                            players[playerIndex] -= 2 * throwResult
                            println(" - double \(throwResult)")
                        default: break;
                    }
                }
            }
            
            players[playerIndex] = max(players[playerIndex], 0)
            println(players[playerIndex])
            
        }
    }

}
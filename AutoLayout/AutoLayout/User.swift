//
//  User.swift
//  AutoLayout
//
//  Created by Alexandre THOMAS on 25/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let company: String
    let login: String
    let password: String
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password {
                return user
            }
        }
        return nil
    }
    
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(name:"Alexandre Thomas", company: "kinja", login: "alex", password: "toto"),
            User(name:"Gabor Szekeres", company: "epam", login: "szeki", password: "toto"),
            User(name:"Peter Szabados", company: "XIII", login: "peter", password: "toto")
            ] {
                theDatabase[user.login] = user
        }
        return theDatabase
    }()
}

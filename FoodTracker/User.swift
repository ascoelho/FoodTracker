//
//  User.swift
//  FoodTracker
//
//  Created by Anthony Coelho on 2016-06-06.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var username: String
    var password: String
    var token: String
    
    
    init?(username: String, password: String, token: String) {
        // Initialize stored properties.
        self.username = username
        self.password = password
        self.token = token
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if username.isEmpty || password.isEmpty {
            return nil
        }
    }
}
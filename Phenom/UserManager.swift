//
//  UserManager.swift
//  Phenom
//
//  Created by Isom Durm on 4/1/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import Foundation

class UserManager {
    
    var username = ""
    var firstName = ""
    var lastName = ""
    var sports = []
    var hometown = ""
    var bio = ""
    
    static let sharedInstance = UserManager()
    
    init() {
        print("username: \(username)")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("sports: \(sports)")
        print("hometown: \(hometown)")
        print("bio: \(bio)")
    }
    
}

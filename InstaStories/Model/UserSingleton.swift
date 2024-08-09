//
//  UserSingleton.swift
//  InstaStories
//
//  Created by Sualp DANACI on 9.08.2024.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
    }
    
    
}

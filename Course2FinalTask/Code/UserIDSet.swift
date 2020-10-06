//
//  Singletone.swift
//  Course2FinalTask
//
//  Created by Igor🛠iOSDev on 01.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

class UserIDSet {
    
    static let shared = UserIDSet()
    
    var userID: User.Identifier?
    var currentUser: User!
    
    private init() {
        DataProviders.shared.usersDataProvider.currentUser(queue: DispatchQueue.global()) { (user) in
            guard let user = user else { return }
            self.currentUser = user
        }
    }
    
}

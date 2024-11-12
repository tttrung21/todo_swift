//
//  UserManager.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/25/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import RxCocoa

class UserManager {
    
    /// The default singleton instance.
    static let shared = UserManager()
    
    let currentUser: BehaviorRelay<TodoUser?>
    
    private init() {
            // Load the saved user data from UserDefaults
            if let userData = UserDefaults.standard.data(forKey: Configs.UserDefaultsKeys.CurrentUser),
               let user = try? JSONDecoder().decode(TodoUser.self, from: userData) {
                currentUser = BehaviorRelay<TodoUser?>(value: user)
            } else {
                currentUser = BehaviorRelay<TodoUser?>(value: nil)
            }
        }
        
        func saveUser(_ user: TodoUser) {
            // Encode the user to JSON data and save it in UserDefaults
            if let userData = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(userData, forKey: Configs.UserDefaultsKeys.CurrentUser)
                currentUser.accept(user)
            }
        }
        
        func removeUser() {
            // Remove user data from UserDefaults and update the relay
            UserDefaults.standard.removeObject(forKey: Configs.UserDefaultsKeys.CurrentUser)
            currentUser.accept(nil)
        }
}

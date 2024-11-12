//
//  MainViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 1/4/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxCocoa
import Supabase

class SplashViewModel: ViewModel {
    private let navigator: SplashNavigator
    
    init(navigator: SplashNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
        
        if ((SupabaseClientManager.shared.client.auth.currentSession?.isExpired) != nil) {
            navigator.pushHome()
        } else {
            navigator.pushSignIn()
        }
    }
}

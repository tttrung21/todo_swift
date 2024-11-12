//
//  SignUpViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/20/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModel {
    // MARK: Public Properties
    
    // MARK: Private Properties
    private let navigator: SignUpNavigator
    
    private let email = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    private let confirm = BehaviorRelay(value: "")

    init(navigator: SignUpNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
    }
    
    // MARK: Public Function
    
    func changeEmail(email: String) -> Void {
        self.email.accept(email)
    }
    
    func changePassword(password: String) -> Void {
        self.password.accept(password)
    }
    
    func changeConfirm(confirm: String) -> Void {
        self.confirm.accept(confirm)
    }
    
    func signUp() {
        guard validation() else{
            return
        }
        SupabaseClientManager.shared.userService.signUp(email: self.email.value, password: self.password.value) .observeOn(MainScheduler.instance).trackActivity(loadingIndicator)
            .subscribe(
                onNext: {
                    user in
//                    UserManager.shared.saveUser(user)
                    print(user.id)
                    self.navigator.pushBackSignIn()
                    },
                onError: {
                    error in
                    self.navigator.showAlert(title: "Common.Error".localized(),
                                             message: error.localizedDescription)
                    }
                ).disposed(by: disposeBag)
    }
    
    // MARK: Private Function
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
    private func validation() -> Bool{
        let email = self.email.value
        if email.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Email.Empty".localized())
            return false
        }
        guard isValidEmail(email) else {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Email.Format".localized())
            return false
        }
        let password = self.password.value
        if password.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Password.Empty".localized())
            return false
        }
        let confirm = self.confirm.value
        if confirm.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Confirm.Password.Empty".localized())
            return false
        }
        if confirm != password {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Confirm.Doesn't.Match".localized())
            return false
        }
        return true
    }
//    private func fetchProfile() {
//        Application.shared
//            .mockProvider
//            .getProfile()
//            .trackActivity(loadingIndicator)
//            .subscribe(onNext: { [weak self] user in
//                guard let self = self else { return }
//                //Save data
//                UserManager.shared.saveUser(user)
//                //Navigate
//                self.navigator.pushHome()
//            }, onError: {[weak self] error in
//                self?.navigator.showAlert(title: "Common.Error".localized(),
//                                          message: "Login.Username.Password.Invalid".localized())
//            }).disposed(by: disposeBag)
//    }
}

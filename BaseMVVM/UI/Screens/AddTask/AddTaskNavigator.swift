//
//  AddTaskNavigator.swift
//  BaseMVVM
//
//  Created by Trung on 6/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import Foundation

class AddTaskNavigator: Navigator {
    func pushBackHome() {
        navigationController?.popViewController(animated: true)
    }
    func pushToHome(){
        let viewController = HomeViewController(nibName: HomeViewController.className, bundle: nil)
        let navigator = HomeNavigator(with: viewController)
        let viewModel = HomeViewModel(navigator: navigator)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

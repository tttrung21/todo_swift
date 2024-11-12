//
//  HomeNavigator.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation

class HomeNavigator: Navigator {
    func pushAddTask(){
        let viewController = AddTaskViewController(nibName: AddTaskViewController.className, bundle: nil)
        let navigator = AddTaskNavigator(with: viewController)
        let viewModel = AddTaskViewModel(navigator: navigator)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

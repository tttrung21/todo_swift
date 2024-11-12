////
////  ListViewModel.swift
////  BaseMVVM
////
////  Created by Lê Thọ Sơn on 4/29/20.
////  Copyright © 2020 thoson.it. All rights reserved.
////
//
//import Foundation
//import RxCocoa
//import RxSwift
//
//class ListViewModel: ViewModel {
//    
//    // MARK: Public Properties
//    let cellVMs = BehaviorRelay<[ItemCellViewModel]>(value: [])
//    
//    // MARK: Private Properties
//    private let navigator: ListNavigator
//    private let todos = BehaviorRelay<[Todo]>(value: [])
//    
//    init(navigator: ListNavigator) {
//        self.navigator = navigator
//        super.init(navigator: navigator)
//        
//        // Setup listener
//        todos.map { todos -> [ItemCellViewModel] in
//            return todos.map { movie -> ItemCellViewModel in
//                return ItemCellViewModel(item: movie)
//            }
//        }.bind(to: cellVMs).disposed(by: disposeBag)
//    }
//    
//    // MARK: Public Function
//    
//    func reloadData() {
//        fetchItems()
//    }
////    
////    func loadMoreData() {
////        fetchItems()
////    }
//    
//    func handleItemTapped(cellVM: ItemCellViewModel) {
//        navigator.pushDetail(data: cellVM.item)
//    }
//    
//    // MARK: Private Function
//    
//    private func fetchItems() {
//        Application.shared.apiProvider.getItems()
//            .trackActivity(ActivityIndicator())
//            .subscribe(
//                onNext: { [weak self] response in
//                    guard let self = self else { return }
//                    if response.results.isEmpty {
//                        return
//                    }
//                }, onError: { [weak self] error in
//                    self?.navigator.showAlert(title: "Error",
//                                              message: error.localizedDescription)
//            }).disposed(by: disposeBag)
//    }
//}

//
//  HomeViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModel {
    
    // MARK: Public Properties
    var todoList:[TodoModel]
    // MARK: Private Properties
    private let navigator: HomeNavigator
    private let todos = BehaviorSubject<[TodoModel]>(value: [])

    var toggle = PublishRelay<TodoModel>()
    init(navigator: HomeNavigator) {
        self.navigator = navigator
        self.todoList = []
        super.init(navigator: navigator)
        
        
        toggle.subscribe(onNext: { [weak self] updatedTodo in
            print("Received updatedTodo in relay with ID:", updatedTodo.id ?? -1)
                        self?.toggleComplete(todo: updatedTodo)
                    })
                    .disposed(by: disposeBag)
        
    }
    // MARK: Public Function
    func openAddTask() {
        navigator.pushAddTask()
    }
    func logout() {
        SupabaseClientManager.shared.userService.logout()
        UserManager.shared.removeUser()
        Application.shared.presentInitialScreen(in: appDelegate.window)
    }
    func switchLanguage() {
        LanguageManager.shared.updateLanguage()
    }
    func deleteItem(todo:TodoModel){
        SupabaseClientManager.shared.todoService.deleteTodo(todo: todo).observeOn(MainScheduler.instance).subscribe(
            onSuccess: {
            _ in 
                self.navigator.showAlert(title: "Common.Success".localized(), message: "Todo.Delete.Success".localized())
                self.fetchItems()
                
            },
            onError: {
                error in
                self.navigator.showAlert(title: "Common.Error".localized(), message: error.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
    func fetchItems() {
        SupabaseClientManager.shared.todoService.getItems().observeOn(MainScheduler.instance).trackActivity(loadingIndicator)
            .subscribe(
            onNext: {
                todos in
                    self.todoList = todos
                    self.todos.onNext(todos)
                },
            onError: {
                error in
                print("Error fetching data: \(error)")
            }
        ).disposed(by: disposeBag)
    }
    var observable: Observable<[TodoModel]>{
        return todos.asObservable()
    }
    
    // MARK: Private Function
    private func toggleComplete(todo:TodoModel){
        print("id : \(String(describing: todo.id))")
        SupabaseClientManager.shared.todoService.toggleIsCompleted(for: todo).observeOn(MainScheduler.instance).subscribe(
        onSuccess: {
                [weak self] _ in
            print("Successfully toggle")
            self?.fetchItems()
        },
        onError: {error in
            print("Error toggling completion status:", error.localizedDescription)
        }
        ).disposed(by: disposeBag)
    }
    
    
    // MARK: Separate VM for test
//    let cellVMs = BehaviorRelay<[TodoCellViewModel]>(value: [])
//    let cellComplete = BehaviorRelay<[TodoCellViewModel]>(value: [])
//    let cellTodo = BehaviorRelay<[TodoCellViewModel]>(value: [])
//
//    private let todosRelay = BehaviorRelay<[TodoModel]>(value: [])
//    func getItem() {
//        SupabaseClientManager.shared.todoService.getItems()
//            .trackActivity(ActivityIndicator())
//            .subscribe(
//                onNext: { [weak self] response in
//                    guard let self = self else { return }
//                    if response.isEmpty {
//                        return
//                    }
//                    self.todosRelay.accept(response)
//                    
//
////                    let completeTodos = response.results.filter { $0.isCompleted == true}
////                    let incompleteTodos = response.results.filter { $0.isCompleted == false }
////                    let completeCellVMs = completeTodos.map { TodoCellViewModel(item: $0) }
////                    let todoCellVMs = incompleteTodos.map { TodoCellViewModel(item: $0) }
////                    self.cellComplete.accept(completeCellVMs)
////                    self.cellTodo.accept(todoCellVMs)
//                    
//                }, onError: { [weak self] error in
//                    self?.navigator.showAlert(
//                        title: "Error",message: error.localizedDescription)
//            }).disposed(by: disposeBag)
//    }
}

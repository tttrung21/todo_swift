//
//  HomeViewController.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: ViewController<HomeViewModel, HomeNavigator> {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoListLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableTodo: UITableView!
//    @IBOutlet weak var tableComplete: UITableView!
    var currentViewController: UIViewController?
    private let refreshControl = UIRefreshControl()
    private var listTodo = [TodoModel]()
    private var listComplete = [TodoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchItems()
        tableTodo.register(nibWithCellClass: TodoTableViewCell.self)
//        tableComplete.register(nibWithCellClass: TodoTableViewCell.self)
        tableTodo.tableFooterView = UIView()
//        tableComplete.tableFooterView = UIView()
        tableTodo.delegate = self
        tableTodo.dataSource = self
//        tableComplete.dataSource = self
//        tableComplete.delegate = self

        tableTodo.register(UINib(nibName:"TodoTableViewCell",bundle: nil), forCellReuseIdentifier: "TodoCell")
//        tableComplete.register(UINib(nibName:"TodoTableViewCell",bundle: nil), forCellReuseIdentifier: "TodoCell")
        self.viewModel.observable.observeOn(MainScheduler.instance).subscribe(onNext: {
            [weak self] todos in
            guard let self = self else {return}
            self.listTodo = todos.filter{ !$0.isCompleted}
            self.listComplete = todos.filter{ $0.isCompleted}
            self.tableTodo.reloadData()
//            self.tableComplete.reloadData()
        }
        ).disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchItems()
        super.viewWillAppear(animated)
    }
    override func setupUI() {
        super.setupUI()
        updateLanguage()
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(rightButtonTapped(sender: )))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe"), style: .plain, target: self, action: #selector(leftButtonTapped(sender: )))
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    override func setupListener() {
        super.setupListener()
        
        addButton.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.viewModel.openAddTask()
        }.disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem!.rx.tap.bind {
            [weak self] in
                guard let self = self else { return }
                self.viewModel.logout()
        }.disposed(by: disposeBag)
        navigationItem.leftBarButtonItem!.rx.tap.bind {
            [weak self] in
                guard let self = self else { return }
                self.viewModel.switchLanguage()
                updateLanguage()
                tableTodo.reloadData()
        }.disposed(by: disposeBag)
//        viewModel.cellTodo.asDriver(onErrorJustReturn: [])
//                    .drive(self.tableTodo.rx.items(cellIdentifier: TodoTableViewCell.className, cellType: TodoTableViewCell.self)) { tableView, viewModel, cell in
//                        cell.bind(viewModel: viewModel)
//                    }.disposed(by: self.disposeBag)
//        viewModel.cellComplete.asDriver(onErrorJustReturn: [])
//                    .drive(self.tableTodo.rx.items(cellIdentifier: TodoTableViewCell.className, cellType: TodoTableViewCell.self)) { tableView, viewModel, cell in
//                        cell.bind(viewModel: viewModel)
//                    }.disposed(by: self.disposeBag)
        
//        viewModel.cellVMs.asDriver(onErrorJustReturn: [])
//            .drive(self.tableTodo.rx.items(cellIdentifier: TodoTableViewCell.className, cellType: TodoTableViewCell.self)) { tableView, cellViewModel, cell in
//                cell.bind(viewModel: cellViewModel)
//            }.disposed(by: disposeBag)
//        
        viewModel.loadingIndicator.asObservable().bind(to: isLoading).disposed(by: disposeBag)
    }
    private func updateLanguage(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Configs.DateFormart.mdy
        dateFormatter.locale = Locale(identifier: LanguageCode)
        let currentDate = dateFormatter.string(from: Date())
        dateLabel.text = currentDate
        todoListLabel.text = "MyTodoList".localized()
        addButton.setTitle("AddNewTask".localized(), for: .normal)
    }
}
extension HomeViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return TodoSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = TodoSection(rawValue: section)!
            switch sectionType {
            case .incomplete:
                return listTodo.count
            case .complete:
                return listComplete.count
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
//        let item = (tableView == tableTodo ? listTodo : listComplete)[indexPath.row]
        let sectionType = TodoSection(rawValue: indexPath.section)!
        let item = (sectionType == .incomplete) ? listTodo[indexPath.row] : listComplete[indexPath.row]
            
        let cellViewModel = TodoCellViewModel(item: item, toggle: self.viewModel.toggle)
        cell.bind(viewModel: cellViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sectionType = TodoSection(rawValue: indexPath.section)!
        let item = (sectionType == .incomplete) ? listTodo[indexPath.row] : listComplete[indexPath.row]
        if editingStyle == .delete{
            self.viewModel.deleteItem(todo: item)
            print(item)
            print(indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TodoSection(rawValue: section)?.title
    }
}

enum TodoSection: Int, CaseIterable {
    case incomplete
    case complete
    
    var title: String {
        switch self {
        case .incomplete: return ""
        case .complete: return "Complete".localized()
        }
    }
}

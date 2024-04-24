
import Foundation
import RxSwift
import RxRelay

class TodoApiService {
    private let apiProvider: TodoApiProvider
    private let disposeBag = DisposeBag()

    // Observable properties to hold the completed and incomplete todos
    var incompleteTodos: BehaviorRelay<[TodoModel]> = BehaviorRelay(value: [])
    var completedTodos: BehaviorRelay<[TodoModel]> = BehaviorRelay(value: [])

    init(apiProvider: TodoApiProvider) {
        self.apiProvider = apiProvider
    }

    // Fetch todos and separate them into completed and incomplete
    func fetchTodos() {
        apiProvider.fetchTodos()
            .subscribe(onNext: { [weak self] todos in
                // Filter todos based on isCompleted flag
                let incomplete = todos.filter { !$0.isCompleted }
                let completed = todos.filter { $0.isCompleted }

                // Update the BehaviorRelays with the filtered data
                self?.incompleteTodos.accept(incomplete)
                self?.completedTodos.accept(completed)
            }, onError: { error in
                print("Error fetching todos: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

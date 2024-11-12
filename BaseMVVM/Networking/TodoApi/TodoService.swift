import Foundation
import Supabase
import RxSwift

class TodoService {
    
    private let disposeBag = DisposeBag()
    private let client: SupabaseClient
//    private let currentUser = UserManager.shared.currentUser.value!
    init(client: SupabaseClient) {
        self.client = client
    }
    func getItems() -> Single<[TodoModel]> {
        guard let currentUser = UserManager.shared.currentUser.value else {
            return Single.error(NSError(domain: "UserService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User is not logged in."]))
        }
            return Single.create { single in
                Task{
                    do{
                        let todos: [TodoModel] = try await self.client.from("Todo").select().eq("user_id", value: currentUser.id.uuidString).execute().value
                        single(.success(todos))
                    }
                    catch{
                        single(.error(error))
                    }
                }
                return Disposables.create()
            }
        }
    func createItem(todo: TodoModel) -> Single<Void> {
        return Single.create { single in
            Task{
                do {
                    try await self.client.from("Todo")
                        .insert([todo])
                        .execute()
                        .value
                    single(.success(()))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    func toggleIsCompleted(for todo: TodoModel) -> Single<TodoModel> {
        return Single.create { single in
            Task {
                do {
                    let isCompleted = !todo.isCompleted
                    let _ = try await self.client.from("Todo")
                        .update(["is_completed": isCompleted])
                        .eq("user_id", value: todo.userId)
                        .eq("id", value: todo.id)
                        .execute()
                    let newTodo = TodoModel(id: todo.id, title: todo.title, notes: todo.notes, category: todo.category, dueDate: todo.dueDate, dueTime: todo.dueTime, isCompleted: isCompleted, userId: todo.userId)
                    single(.success(newTodo))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    func deleteTodo(todo: TodoModel) -> Single<Void> {
        return Single.create { single in
            print("delete todo")
            Task {
                print("task start")
                do {
                    let response = try await self.client.from("Todo")
                        .delete()
                        .eq("id", value: todo.id)
                        .eq("user_id", value: todo.userId)
                        .execute()

                    print("success delete service: \(response)")
                    single(.success(()))
                } catch {
                    print("fail delete service")
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

}

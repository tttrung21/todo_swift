
import Foundation
import RxRelay
class TodoCellViewModel : CellViewModel{
    let item: TodoModel
    var toggle : PublishRelay<TodoModel>
    
    init(item: TodoModel, toggle: PublishRelay<TodoModel>) {
        self.item = item
        self.toggle = toggle
        super.init()
        self.title.accept(item.title)
        self.notes.accept(item.notes)
        self.id.accept(item.id)
        self.category.accept(item.category)
        self.dueDate.accept(item.dueDate)
        self.dueTime.accept(item.dueTime)
        self.isCompleted.accept(item.isCompleted)
    }
    func toggleComplete() {
        print("Attempting to toggle item:", item)
        toggle.accept(item)
    }
}

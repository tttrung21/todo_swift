import Foundation
import RxSwift
import RxCocoa

class AddTaskViewModel : ViewModel{
    
    private let navigator: AddTaskNavigator
    private(set) var currentCategory: String?
    init(navigator: AddTaskNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
    }
    
    func backToHome() {
        navigator.pushBackHome()
    }
    func pushToHome() {
        navigator.pushToHome()
    }
    private let selectedButtonSubject = BehaviorSubject<String?>(value: nil)
        
        // Observable for selected button
    var selectedButton: Observable<String?> {
        return selectedButtonSubject.asObservable()
    }
        
    // Method to handle button tap events
    func handleButtonTap(_ category: String) {
        // Check if the tapped button is already selected
        if let currentSelectedButton = try? selectedButtonSubject.value(), currentSelectedButton == category {
            selectedButtonSubject.onNext(nil)
            currentCategory = nil
        } else {
            selectedButtonSubject.onNext(category)
            currentCategory = category
        }
    }
    func createItem(with title: String, dueDate: String,dueTime: String, notes: String?) -> Single<Void>{
        switch validate(title: title, dueDate: dueDate, dueTime: dueTime) {
        case .failure(let error):
            return .error(error)
        case .success:
            break
        }
        
        guard let userId = UserManager.shared.currentUser.value?.id else{
            return .error(NSError(domain: "Auth", code: 10, userInfo: [NSLocalizedDescriptionKey: "Not logged in"]))
        }
        let category = currentCategory!
        let time = convertTo12HourFormat(timeString: dueTime)!
        let newItem = TodoModel(id: nil, title: title, notes: notes, category: category, dueDate: dueDate,dueTime: time, isCompleted: false, userId: userId)
        return SupabaseClientManager.shared.todoService.createItem(todo: newItem)
    }
    
    func validate(title: String, dueDate: String, dueTime: String) -> Result<Void, Error> {
        guard !title.isEmpty else {
            return .failure(NSError(domain: "AddTask", code: 1, userInfo: [NSLocalizedDescriptionKey: "Title cannot be empty"]))
        }
        guard currentCategory != nil else {
            return .failure(NSError(domain: "AddTask", code: 2, userInfo: [NSLocalizedDescriptionKey: "No category selected"]))
        }
        
        guard !dueDate.isEmpty else {
            return .failure(NSError(domain: "AddTask", code: 3, userInfo: [NSLocalizedDescriptionKey: "Due date cannot be empty"]))
        }
        guard !dueTime.isEmpty else {
            return .failure(NSError(domain: "AddTask", code: 4, userInfo: [NSLocalizedDescriptionKey: "Due time cannot be empty"]))
        }
        guard let _ = convertTo12HourFormat(timeString: dueTime) else {
            return .failure(NSError(domain: "AddTask", code: 5, userInfo: [NSLocalizedDescriptionKey: "Wrong time format"]))
        }
        return .success(())
    }
    
    func convertTo12HourFormat(timeString: String) -> String? {
        let timeFormatter24Hour = DateFormatter()
        timeFormatter24Hour.dateFormat = "HH:mm"
        
        if let date = timeFormatter24Hour.date(from: timeString) {
            let timeFormatter12Hour = DateFormatter()
            timeFormatter12Hour.dateFormat = "hh:mm a"
                        return timeFormatter12Hour.string(from: date)
        }
        
        return nil
    }
}

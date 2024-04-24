import Foundation

class ServiceContainer {
    static let shared = ServiceContainer()

    // Lazy initialization of services
    private(set) lazy var todoService: TodoService = TodoService()
    private(set) lazy var userService: UserService = UserService()
    
    // Other services can be added here in the future
    
    private init() {}
}

import Foundation
import Supabase

class SupabaseClientManager {
    
    static let shared = SupabaseClientManager()
    
    let client = SupabaseClient(supabaseURL: URL(string: Configs.Network.apiBaseUrl)!, supabaseKey: Configs.Network.apiKey)
    var userService: UserService
    var todoService: TodoService
        
    private init() {
        self.userService = UserService(client: client)
        self.todoService = TodoService(client: client)
    }
    
}

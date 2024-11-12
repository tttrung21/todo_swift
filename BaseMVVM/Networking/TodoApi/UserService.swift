import Foundation
import RxSwift
import Supabase

class UserService{
    private let client : SupabaseClient
    private let userDefault = UserDefaults.standard
    
    init(client: SupabaseClient) {
        self.client = client
    }
    func signUp(email: String, password: String) -> Single<TodoUser> {
            return Single.create { single in
                Task {
                    do {
                        let session = try await self.client.auth.signUp(email: email, password: password)
                        
                        let userId = session.user.id
                        let user = TodoUser(id: userId, email: email)
                        single(.success(user))
                        
                    } catch {
                        single(.error(error))
                    }
                }
                return Disposables.create()
            }
        }

    func signIn(email: String, password: String) -> Single<TodoUser> {
        return Single.create { single in
            Task {
                do {
                    let session = try await self.client.auth.signIn(email: email, password: password)
                    let userId = session.user.id
                    var user = TodoUser(id: userId, email: email)
                    single(.success(user))
                    
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    func logout(){
            Task{
                do{
                    try await self.client.auth.signOut()
                }
                catch{
                    print(error)
                }
            }
    }
}

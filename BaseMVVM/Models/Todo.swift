import Foundation
import ObjectMapper

struct TodoModel: Codable,Identifiable,Hashable{
    let id:Int?
    let title:String
    let notes:String?
    let category:String
    let dueDate:String
    let dueTime:String?
    var isCompleted:Bool = false
    let userId: UUID?
    
    enum CodingKeys: String,CodingKey{
        case id,title,notes,category
        case dueDate = "due_date"
        case dueTime = "due_time"
        case isCompleted = "is_completed"
        case userId = "user_id"
    }
}

class Todo: Mappable {
    var id: Int?
    var title: String = ""
    var notes:String?
    var category:String = ""
    var dueDate:String = ""
    var isCompleted:Bool = false
//    var userId: UUID?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        title                <- map["title"]
        notes            <- map["notes"]
        category          <- map["category"]
        dueDate           <- map["due_date"]
        isCompleted           <- map["is_completed"]
//        userId            <- map["user_id"]
    }
}

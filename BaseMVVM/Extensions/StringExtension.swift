//import Foundation
//
//extension String {
//    static func combineToTimestamptz(dateString: String, timeString: String) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 7 * 60 * 60) // GMT+7
//        
//        guard let datePart = dateFormatter.date(from: dateString) else {
//            return nil
//        }
//        
//        // Combine date and time using the calendar
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month, .day], from: datePart)
//        
//        dateFormatter.dateFormat = "HH:mm"
//        guard let timePart = dateFormatter.date(from: timeString) else {
//            return nil
//        }
//        
//        let timeComponents = calendar.dateComponents([.hour, .minute], from: timePart)
//        components.hour = timeComponents.hour
//        components.minute = timeComponents.minute
//        
//        guard let combinedDate = calendar.date(from: components) else {
//            return nil
//        }
//        
//        // Convert to ISO 8601 format with timezone
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.timeZone = TimeZone(secondsFromGMT: 7 * 60 * 60) // GMT+7
//        return isoFormatter.string(from: combinedDate)
//    }
//}

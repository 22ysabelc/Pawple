//
//  CommonFunctions.swift
//  Pawple
//
//  Created by 22ysabelc on 8/9/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject {
    class func getTimeStamp(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        print(localDate)
        
        var formattedString = ""
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: Date())
        
        if let year = interval.year, year > 0 {
            if year == 1 {
                formattedString = "1 year ago"
            } else {
                formattedString = "\(year)" + " " + "years ago"
            }
        } else if let month = interval.month, month > 0 {
            if month == 1 {
                formattedString = "1 month ago"
            } else {
                formattedString = "\(month)" + " " + "months ago"
            }
        } else if let day = interval.day, day > 0 {
            if day == 1 {
                formattedString = "1 day ago"
            } else {
                formattedString = "\(day)" + " " + "days ago"
            }
        } else if let hour = interval.hour, hour > 0 {
            if hour == 1 {
                formattedString = "1 hour ago"
            } else {
                formattedString = "\(hour)" + " " + "hours ago"
            }
        } else if let minute = interval.minute, minute > 0 {
            if minute == 1 {
                formattedString = "1 min ago"
            } else {
                formattedString = "\(minute)" + " " + "mins ago"
            }
        } else {
            formattedString = "Just now"
        }
        
        return formattedString
    }
}

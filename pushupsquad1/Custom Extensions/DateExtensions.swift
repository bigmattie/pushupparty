//
//  DateExtensions.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/12/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import Foundation




//Get Current Month
//Date.Get Current Month
extension Date {
    static func getCurrentMonth() -> [String] {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let thisMonth = dateFormatter.string(from: now)
        dateFormatter.dateFormat = "MM"
        let thisMonthNumber = dateFormatter.string(from: now)
        
        //returns array of this Month and Months number ex. May, 05
        return [ thisMonth, thisMonthNumber ]
    }
}
//Get last 7 days////
//
//
//extension Date {
//    static func getDates(forLastNDays nDays: Int) -> [String] {
//        let cal = Calendar.current
//        // start with today
//        var date = cal.date(byAdding: Calendar.Component.day, value: +1, to: Date())!
//
//        var arrDates = [String]()
//
//        for _ in 1 ... nDays {
//            // move back in time by one day:
//            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
//
//            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "dd-MM-YYYY"
//            dateFormatter.dateFormat = "dd-MM-YYYY"
//            let dateString = dateFormatter.string(from: date)
//
//            arrDates.append(dateString)
//        }
//        print(arrDates)
//        return arrDates
//    }
//}



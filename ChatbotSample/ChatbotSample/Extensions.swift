//
//  Extensions.swift
//  ChatbotSample
//
//  Created by Vinay Podili on 23/01/19.
//  Copyright © 2019 Brighterbee. All rights reserved.
//

import UIKit
import Foundation
extension Date {
    var currentLocaleDate : String {
        Formatter.date.calendar = Calendar(identifier: .iso8601)
        Formatter.date.locale   = Locale.current
        Formatter.date.timeZone = .current
        Formatter.date.dateFormat = "H:mm a"//"dd/M/yyyy, H:mm a"
        return Formatter.date.string(from: self)
    }
}
extension Formatter {
    static let date = DateFormatter()
}
extension String {
    var date: Date? {
        return Formatter.date.date(from: self)
    }
    func dateFormatted(with dateFormat: String = "dd/M/yyyy, H:mm a", calendar: Calendar = Calendar(identifier: .iso8601), defaultDate: Date? = nil, locale: Locale = Locale(identifier: "en_US_POSIX"), timeZone: TimeZone = .current) -> Date? {
        Formatter.date.calendar = calendar
        Formatter.date.defaultDate = defaultDate ?? calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateFormat = dateFormat
        return Formatter.date.date(from: self)
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func getPrefix(word: String, character: String) ->String {
        if let index = word.range(of: character)?.lowerBound {
            let substring = word[..<index]                 // "ora"
            // or  let substring = word.prefix(upTo: index) // "ora"
            // (see picture below) Using the prefix(upTo:) method is equivalent to using a partial half-open range as the collection’s subscript.
            // The subscript notation is preferred over prefix(upTo:).
            
            let string = String(substring)
            print("***: \(string)")  // "ora"
            return string
        }
        return ""
    }
}


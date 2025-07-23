//
//  String+Date.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case dd_MMMM_yyyy = "dd MMMM, yyyy"
    case MMM_d = "MMM d"
    case EEEE
    case EEE
    case HHmmss = "HH:mm:ss"
    case hmm_a = "h:mm a"
}

extension String {
    func toFormatedDate(format: DateFormat = .dd_MMMM_yyyy, from: DateFormat = .yyyyMMdd) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: self) else {
            return self
        }

        dateFormatter.dateFormat = format.rawValue

        return dateFormatter.string(from: date)
    }
}

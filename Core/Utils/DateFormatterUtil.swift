//
//  DateFormatterUtil.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI

class DateFormatterUtil {
    static let dateFormatDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let dateFormatTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

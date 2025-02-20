//
//  DateFormatterUtil.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI

public class DateFormatterUtil {
    public static let dateFormatDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public static let dateFormatTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}

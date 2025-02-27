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
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    // MM.dd 오후 HH:mm
    public static let dateToDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd a hh:mm"
        return formatter
    }()
    
    // M월d일 (요일)
    public static let dateToDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d (E)"
        return formatter
    }()

    // 오후 HH:mm
    public static let dateToTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        return formatter
    }()
}

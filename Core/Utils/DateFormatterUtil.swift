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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ✅ 서버에서 기대하는 ISO 8601 형식
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // ✅ UTC로 변환하면 안됨
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}

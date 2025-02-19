//
//  HomeViewModel.swift
//  Features
//
//  Created by 김영훈 on 2/18/25.
//

import Foundation

public class HomeViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    var selectedWeekString = ""
    private var startOfWeek = Date()
    private var endOfWeek = Date()
    //TODO: API 연동, selectedDate에 따라 갱신
    var weeklyExercisePoints: [ExercisePoint] = [
        ExercisePoint(exerciseType: "달리기", point: 50),
        ExercisePoint(exerciseType: "HIIT", point: 50),
        ExercisePoint(exerciseType: "수영", point: 50),
        ExercisePoint(exerciseType: "테니스", point: 50),
    ]
    
    // 주의 첫날과 마지막날 날짜 구하기
    private func getStartAndEndOfWeek(from date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        
        if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: weekInterval.start) {
            return (weekInterval.start, endOfWeek)
        } else {
            return nil
        }
    }
    
    // 주의 첫날과 마지막날 날짜 업데이트
    func updateStartAndEndOfWeek() {
        if let (startOfWeek, endOfWeek) = self.getStartAndEndOfWeek(from: selectedDate) {
            self.startOfWeek = startOfWeek
            self.endOfWeek = endOfWeek
        }
    }
    
    // Date yyyy-MM-dd 형식으로 바꾸기
    private func getStringFromDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }
    
    func getSelectedWeekString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let selectedWeekString = "\(formatter.string(from: startOfWeek)) ~ \(formatter.string(from: endOfWeek))"
        return selectedWeekString
    }
}

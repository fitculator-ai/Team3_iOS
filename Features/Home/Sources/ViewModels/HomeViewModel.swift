//
//  HomeViewModel.swift
//  Features
//
//  Created by 김영훈 on 2/18/25.
//

import Foundation
import Combine
import Core
import SwiftUICore

public class HomeViewModel: ObservableObject {
    //TODO: API 연동, selectedDate에 따라 갱신
    //TODO: workoutRecords 갱신되면 -> workoutRecordPointSums 갱신 -> 파이차트 갱신
    @Published var selectedDate: Date = Date()
    @Published public var workoutData: WorkoutData?
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    var selectedWeekString = ""
    private var startOfWeek = Date()
    private var endOfWeek = Date()
    var workoutRecordPointSums: [WorkoutRecordPointSum] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchWeeklyWorkout(userId: Int, targetDate: String) {
        isLoading = true
        networkService.request(APIEndpoint.getWeeklyWorkout(userId: userId, targetDate: targetDate))
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("Error: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] (response: WeeklyWorkoutResponse) in
                    self?.workoutData = response.data
                    self?.updateWorkoutRecordSum(weeklyWorkoutDataRecords: response.data.records)
                }
            )
            .store(in: &cancellables)
    }
    
    // 주의 첫날과 마지막날 날짜 구하기
    func getStartAndEndOfWeek(from date: Date) -> (start: Date, end: Date)? {
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
    
    func getSelectedWeekString() -> String {
        if let todayWeek = getStartAndEndOfWeek(from: Date()),
           let selectedDateWeek = getStartAndEndOfWeek(from: selectedDate), todayWeek == selectedDateWeek {
            return "이번주 운동량"
        }
        if let todayWeek = getStartAndEndOfWeek(from: Date()),
           let nextWeekFromSelectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate),
           let nextWeekFromSelectedWeek = getStartAndEndOfWeek(from: nextWeekFromSelectedDate),
           todayWeek == nextWeekFromSelectedWeek {
            return "지난주 운동량"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let selectedWeekString = "\(formatter.string(from: startOfWeek)) ~ \(formatter.string(from: endOfWeek))"
        return selectedWeekString
    }
    
    func getStrenthCount() -> Int {
        guard let weekStrengthCount = workoutData?.weekStrengthCount else { return 0}
        return weekStrengthCount
    }
    
    func getWeekIntensityPoint() -> Double {
        guard let weekIntensity = workoutData?.weekIntensity else { return 0.0 }
        switch weekIntensity {
        case "VERY LOW" :
            return 0.0
        case "LOW" :
            return 0.25
        case "MEDIUM" :
            return 0.5
        case "HIGH" :
            return 0.75
        case "VERY HIGH" :
            return 1.0
        default:
            return 0.0
        }
    }
    
    func getWeekIntensityString() -> String {
        guard let weekIntensity = workoutData?.weekIntensity else { return "운동이 부족합니다" }
        return weekIntensity
    }
    
    // PieChart를 위한 데이터 변환
    private func updateWorkoutRecordSum(weeklyWorkoutDataRecords: [WorkoutRecord]) {
        let grouped = Dictionary(grouping: weeklyWorkoutDataRecords) { $0.exerciseKorName }
        var result: [WorkoutRecordPointSum] = []
        
        for (exerciseKorName, records) in grouped {
            let totalPoints = records.reduce(0) { $0 + Double($1.recordPoint) }
            let exerciseImg = records.first?.exerciseImg ?? ""
            let exerciseColor = Color(hex: records.first?.exerciseColor ?? "#000000")
            
            result.append(WorkoutRecordPointSum(
                exerciseKorName: exerciseKorName,
                exerciseImg: exerciseImg,
                recordPointSum: totalPoints,
                exerciseColor: exerciseColor
            ))
        }
        
        workoutRecordPointSums = result
    }
    
    func getSelectedDateString() -> String {
        let dateFormatter = DateFormatterUtil.dateFormatDate
        return dateFormatter.string(from: selectedDate)
    }
}

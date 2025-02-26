//
//  HomeViewModel.swift
//  Features
//
//  Created by 김영훈 on 2/18/25.
//

import Foundation
import SwiftUI
import Combine
import Core
import SwiftUICore

public class HomeViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published public var workoutData: WorkoutData?
    @Published var pointPercentageDifference: Int = 0
    @Published var firstWorkoutDate: Date = Date()
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
        let currentWorkoutPublisher = networkService.request(APIEndpoint.getWeeklyWorkout(userId: userId, targetDate: targetDate))
            .map { (response: WeeklyWorkoutResponse) -> (workoutData: WorkoutData, weeklyWorkoutPoint: Int) in
                        let workoutPoint = response.data.records.reduce(0) { $0 + Int($1.recordPoint) }
                        return (response.data, workoutPoint)
                    }
            .receive(on: DispatchQueue.main)

        let previousWorkoutPublisher = networkService.request(APIEndpoint.getWeeklyWorkout(userId: userId, targetDate: getPreviousWeekDate(from: targetDate)))
            .map { (response: WeeklyWorkoutResponse) -> Int in
                return response.data.records.reduce(0) { $0 + Int($1.recordPoint) }
            }
            .receive(on: DispatchQueue.main)
        
        Publishers.Zip(currentWorkoutPublisher, previousWorkoutPublisher)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("Error: \(error.localizedDescription)")
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] (currentWorkout, previousWorkoutPoint) in
                    self?.workoutData = currentWorkout.workoutData
                    self?.pointPercentageDifference = currentWorkout.weeklyWorkoutPoint - previousWorkoutPoint
                    self?.updateWorkoutRecordSum(weeklyWorkoutDataRecords: currentWorkout.workoutData.records)
                }
            )
            .store(in: &cancellables)
    }
    
    // 운동 기록이 있는 최초 날짜 불러오기
    func fetchFirstWorkoutDate(userId: Int) {
        networkService.request(APIEndpoint.getFirstWorkoutDate(userId: userId))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (response: FirstWorkoutResponse) in
                let dateFormatter = DateFormatterUtil.dateFormatDate
                if let firstWorkoutDate = dateFormatter.date(from: response.data) {
                    self?.firstWorkoutDate = firstWorkoutDate
                }
            })
            .store(in: &cancellables)
    }
    
    func updateWorkoutMemo(request: WorkoutUpdateRequest) {
        networkService.request(APIEndpoint.updateWorkout(request: request))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("메모 업데이트 실패: \(error.localizedDescription)")
                    }
                },
                receiveValue: { (response: WorkoutResponse) in
                    print("메모 업데이트 성공: \(response.message)")
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteWorkout(userId: Int, recordId: Int) {
        networkService.request(APIEndpoint.deleteWorkout(userId: userId, recordId: recordId))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("삭제 실패: \(error.localizedDescription)")
                    }
                },
                receiveValue: { (response: WorkoutResponse) in
                    print("삭제 성공: \(response.message)")
                }
            )
            .store(in: &cancellables)
    }
    private func getPreviousWeekDate(from targetDate: String) -> String {
        let dateFormatter = DateFormatterUtil.dateFormatDate
        guard let date = dateFormatter.date(from: targetDate), let previousDate = Calendar.current.date(byAdding: .day, value: -7, to: date) else { return targetDate }
        return dateFormatter.string(from: previousDate)
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
    
    func checkIsCurrentWeek() -> Bool {
        if let todayWeek = getStartAndEndOfWeek(from: Date()),
           let selectedDateWeek = getStartAndEndOfWeek(from: selectedDate), todayWeek == selectedDateWeek {
            return true
        }
        return false
    }
    
    func checkIsFirstWeek() -> Bool {
        if let selectedWeek = getStartAndEndOfWeek(from: selectedDate),
           let firstWorkoutWeek = getStartAndEndOfWeek(from: firstWorkoutDate),
           selectedWeek == firstWorkoutWeek {
            return true
        }
        return false
    }
    
    func getSelectedWeekString() -> String {
        if let todayWeek = getStartAndEndOfWeek(from: Date()),
           let selectedDateWeek = getStartAndEndOfWeek(from: selectedDate), todayWeek == selectedDateWeek {
            return NSLocalizedString("thisWeeksExerciseAmount", comment: "")
        }
        if let todayWeek = getStartAndEndOfWeek(from: Date()),
           let nextWeekFromSelectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate),
           let nextWeekFromSelectedWeek = getStartAndEndOfWeek(from: nextWeekFromSelectedDate),
           todayWeek == nextWeekFromSelectedWeek {
            return NSLocalizedString("lastWeeksExerciseAmount", comment: "")
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
    
    func getDateToTime(dateString: String) -> String {
        if let date = DateFormatterUtil.dateFormatTime.date(from: dateString) {
            let dateToTime = DateFormatterUtil.dateToTime.string(from: date)
            return dateToTime
        }
        return ""
    }
    
    func getDateToDay(dateString: String) -> String {
        if let date = DateFormatterUtil.dateFormatTime.date(from: dateString) {
            let dateToDay = DateFormatterUtil.dateToDay.string(from: date)
            return dateToDay
        }
        return ""
    }
    
    func getDateToDateTime(dateString: String) -> String {
        if let date = DateFormatterUtil.dateFormatTime.date(from: dateString) {
            let dateToDateTime = DateFormatterUtil.dateToDateTime.string(from: date)
            return dateToDateTime
        }
        return ""
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
    
    func getIntensityColor(_ intensity: String) -> Color {
        return ExerciseIntensity.from(intensity).color
    }
    
    func getIntensityText(_ intensity: String) -> String {
        return ExerciseIntensity.from(intensity).koreanText
    }
    
    func getWeekIntensityPercentage(_ intensity: String) -> Double {
        return ExerciseIntensity.from(intensity).progressPercentage
    }
    
    enum ExerciseIntensity: String {
        case veryHigh = "VERY HIGH"
        case high = "HIGH"
        case medium = "MEDIUM"
        case low = "LOW"
        case veryLow = "VERY LOW"
        
        var koreanText: String {
            switch self {
            case .veryHigh: return NSLocalizedString("veryHigh", comment: "")
            case .high: return NSLocalizedString("high", comment: "")
            case .medium: return NSLocalizedString("medium", comment: "")
            case .low: return NSLocalizedString("low", comment: "")
            case .veryLow: return NSLocalizedString("veryLow", comment: "")
            }
        }
        
        var color: Color {
            switch self {
            case .veryHigh: return .red
            case .high: return .purple
            case .medium: return Color.fitculatorLogo
            case .low: return .yellow
            case .veryLow: return .green
            }
        }
        
        var progressPercentage: Double {
            switch self {
            case .veryLow : return 0.0
            case .low : return 0.25
            case .medium : return 0.5
            case .high : return 0.75
            case .veryHigh : return 1.0
            }
        }
        
        static func from(_ intensity: String) -> ExerciseIntensity {
            return ExerciseIntensity(rawValue: intensity) ?? .medium
        }
    }
}

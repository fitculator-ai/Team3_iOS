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

public class HomeViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published public var workoutData: WorkoutData?
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
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
    private var strengthPoint: Int = 3
    private var workoutLoad: Double = 0.5
    
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
                    print("\(response)")
                    self?.workoutData = response.data
                }
            )
            .store(in: &cancellables)
    }
    
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
    
    func getSelectedWeekString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let selectedWeekString = "\(formatter.string(from: startOfWeek)) ~ \(formatter.string(from: endOfWeek))"
        return selectedWeekString
    }
    
    func getStrenthPoint() -> String {
        return "\(strengthPoint)"
    }
    
    func getWorkoutLoad() -> Double {
        return workoutLoad
    }
    
    func getIntensityColor(_ intensity: String) -> Color {
        return ExerciseIntensity.from(intensity).color
    }

    func getIntensityText(_ intensity: String) -> String {
        return ExerciseIntensity.from(intensity).koreanText
    }
    
    enum ExerciseIntensity: String {
        case veryHigh = "VERY HIGH"
        case high = "HIGH"
        case medium = "MEDIUM"
        case low = "LOW"
        case veryLow = "VERY LOW"
        
        var koreanText: String {
            switch self {
            case .veryHigh: return "매우 높음"
            case .high: return "높음"
            case .medium: return "보통"
            case .low: return "낮음"
            case .veryLow: return "매우 낮음"
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
        
        static func from(_ intensity: String) -> ExerciseIntensity {
            return ExerciseIntensity(rawValue: intensity) ?? .medium
        }
    }
}

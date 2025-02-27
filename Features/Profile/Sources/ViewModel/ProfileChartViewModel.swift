//
//  ProfileChartViewmodel.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation
import Combine
import Core

class ProfileChartViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published public var workoutData: WorkoutData?
    @Published var weeklyWorkoutData: [WorkoutData] = [] // 타입을 WorkoutData로 변경
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        $selectedDate
            .removeDuplicates() // 같은 날짜 선택 시 중복 호출 방지
            .sink { [weak self] newDate in
                self?.fetchWeeklyWorkout(userId: 1, targetDate: self?.getSelectedDateString() ?? "")
            }
            .store(in: &cancellables)
    }
    
    // 주간 운동 데이터를 가져오는 메서드
    func fetchWorkoutData(userId: Int, forDate date: String) -> AnyPublisher<WorkoutData, Error> {
        return networkService.request(APIEndpoint.getWeeklyWorkout(userId: userId, targetDate: date))
            .map { (response: WeeklyWorkoutResponse) in
                return response.data // WeeklyWorkoutResponse에서 data 추출
            }
            .eraseToAnyPublisher()
    }

    // 주간 운동 데이터 가져오기
    func fetchWeeklyWorkout(userId: Int, targetDate: String) {
        isLoading = true
        let dateFormatter = DateFormatterUtil.dateFormatDate

        guard let targetDate = dateFormatter.date(from: targetDate) else {
            print("Invalid target date format")
            isLoading = false
            return
        }

        guard let (startOfWeek, endOfWeek) = getStartAndEndOfWeek(from: targetDate) else {
            print("Failed to get the start and end of the week")
            isLoading = false
            return
        }

        let middleDate = getMiddleDate(from: startOfWeek, endOfWeek: endOfWeek)

        let startDate = dateFormatter.string(from: startOfWeek)
        let middleDateString = dateFormatter.string(from: middleDate)
        let endDate = dateFormatter.string(from: endOfWeek)

        // 각 날짜에 맞는 운동 데이터를 가져오는 퍼블리셔 생성
        let startWorkoutPublisher = fetchWorkoutData(userId: userId, forDate: startDate)
        let middleWorkoutPublisher = fetchWorkoutData(userId: userId, forDate: middleDateString)
        let endWorkoutPublisher = fetchWorkoutData(userId: userId, forDate: endDate)

        // 퍼블리셔 연결 및 데이터를 병합하여 가져오기
        startWorkoutPublisher
            .flatMap { firstData -> AnyPublisher<(WorkoutData, WorkoutData), Error> in
                return middleWorkoutPublisher.map { secondData in
                    return (firstData, secondData)
                }
                .eraseToAnyPublisher()
            }
            .flatMap { firstAndSecondData -> AnyPublisher<(WorkoutData, WorkoutData, WorkoutData), Error> in
                let (firstData, secondData) = firstAndSecondData
                return endWorkoutPublisher.map { thirdData in
                    return (firstData, secondData, thirdData)
                }
                .eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("Error: \(error.localizedDescription)")
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] firstData, secondData, thirdData in
                    DispatchQueue.main.async {
                        // 데이터를 weeklyWorkoutData에 저장 (WorkoutData로 직접 저장)
                        self?.weeklyWorkoutData = [firstData, secondData, thirdData]
                        self?.isLoading = false
                    }
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

    // 주의 중간 날짜를 구하는 메서드
    func getMiddleDate(from startOfWeek: Date, endOfWeek: Date) -> Date {
        return startOfWeek.addingTimeInterval((endOfWeek.timeIntervalSince(startOfWeek) / 2))
    }

    // 선택된 날짜를 String으로 변환
    func getSelectedDateString() -> String {
        let dateFormatter = DateFormatterUtil.dateFormatDate
        return dateFormatter.string(from: selectedDate)
    }
    
    // 선택된 주를 반환하는 메서드
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
        let selectedWeekString = "\(formatter.string(from: selectedDate)) ~ \(formatter.string(from: endDate))"
        return selectedWeekString
    }
}

//
//  MyWorkoutViewModel.swift
//  Features
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Core
import Foundation
import Combine

final class MyWorkoutViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    @Published public var workoutRecords: [WorkoutRecord] = []
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    public func fetchWeeklyWorkout(userId: Int, targetDate: String) {
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
                    self?.workoutRecords = response.data.records
                }
            )
            .store(in: &cancellables)
    }
}

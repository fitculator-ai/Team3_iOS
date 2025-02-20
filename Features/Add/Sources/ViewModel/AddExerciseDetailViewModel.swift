//
//  AddExerciseDetailViewModel.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI
import Core
import Combine

class AddExerciseDetailViewModel: ObservableObject {
    @Published var averageHeartRate: String = ""
    @Published var maxHeartRate: String = ""
    @Published var workoutDuration: String = ""
    @Published var workoutMemo: String = ""
    @Published var selectedDate = Date()
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    @Published var addWorkout: WorkoutRequest = WorkoutRequest(userId: 0,
                                                               exerciseType: "",
                                                               exerciseKorName: "",
                                                               exerciseEngName: "",
                                                               recordDate: "",
                                                               recordStart: "",
                                                               duration: 0,
                                                               avgHeartRate: 0,
                                                               highHeartRate: 0,
                                                               memo: "")
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    public func fetchCreateWorkout(request: WorkoutRequest) {
        networkService.request(APIEndpoint.createWorkout(request: request))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] (response: WorkoutRequest) in
                    print("\(response)")
                    self?.addWorkout = response
                }
            )
            .store(in: &cancellables)
    }
}

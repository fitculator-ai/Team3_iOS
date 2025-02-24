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
    @Published var avgHeartRate: String = ""
    @Published var maxHeartRate: String = ""
    @Published var duration: String = ""
    @Published var memo: String = ""
    @Published var selectedDate = Date()
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCreateWorkout(request: WorkoutRequest) {
        networkService.request(APIEndpoint.createWorkout(request: request))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    print("오류: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { (responseData: AddExerciseTypeResponse) in
                print(responseData.message)
            })
            .store(in: &cancellables)
    }
}

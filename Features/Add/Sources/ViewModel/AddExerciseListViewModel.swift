//
//  AddExerciseListViewModel.swift
//  Fitculator
//
//  Created by Song Kim on 2/14/25.
//

import SwiftUI
import Core
import Combine

class AddExerciseListViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var exerciseCardioList = [ExerciseType]()
    @Published var exerciseStrengthList = [ExerciseType]()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchAddExerciseList(exerciseType: String, userId: String) {
        networkService.request(APIEndpoint.getExercises(exerciseType: exerciseType, userId: userId))
            .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    print("오류: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { (response: ExerciseTypeResponse) in
                if exerciseType == "CARDIO" {
                    self.exerciseCardioList = response.data
                } else {
                    self.exerciseStrengthList = response.data
                }
            })
            .store(in: &cancellables)
    }
}

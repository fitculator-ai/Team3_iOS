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
            .receive(on: DispatchQueue.main)
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
    
    func fetchAddFavoriteExercise(userId: Int, exerciseId: Int) {
        let request = FavoriteRequest(userId: userId, exerciseId: exerciseId)
        
        networkService.request(APIEndpoint.addFavorite(request: request))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    print("오류: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { (responseData: FavoriteResponse) in
                if responseData.success {
                    print("✅ 즐겨찾기 추가 성공")
                } else {
                    debugPrint("📢 Raw Response:", responseData)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchRemoveFavoriteExercise(userId: Int, exerciseId: Int) {
        let request = FavoriteRequest(userId: userId, exerciseId: exerciseId)
        
        networkService.request(APIEndpoint.removeFavorite(request: request))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                switch completion {
                case .failure(let error):
                    print("오류: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { (responseData: FavoriteResponse) in
                if responseData.success {
                    print("✅ 즐겨찾기 삭제 성공")
                } else {
                    debugPrint("📢 Raw Response:", responseData)
                }
            })
            .store(in: &cancellables)
    }
}

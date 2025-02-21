//
//  AddExerciseDetailViewModel.swift
//  Fitculator
//
//  Created by Song Kim on 2/17/25.
//

import SwiftUI
import Core
import Combine
import Alamofire

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
    
    public func fetchAddExercises(_ workoutData: WorkoutRequest) {
        let url = "http://13.125.175.216:8080/api/workout"

        AF.request(url, method: .post, parameters: workoutData, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: WorkoutRequestResponse.self) { response in
                switch response.result {
                case .success(let result):
                    print("✅ Success: ")
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            }
    }
}

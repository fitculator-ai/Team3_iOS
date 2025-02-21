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

public class AddExerciseDetailViewModel: ObservableObject {
    @Published var avgHeartRate: String = ""
    @Published var maxHeartRate: String = ""
    @Published var duration: String = ""
    @Published var memo: String = ""
    @Published var selectedDate = Date()
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    public func fetchCreateWorkout(request: WorkoutRequest) {
        networkService.request(APIEndpoint.createWorkout(request: request))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(_) = completion {
                    }
                },
                receiveValue: { (responseData: Data) in
                    if responseData.isEmpty {
                        print("✅ 서버 응답이 비어 있음 (정상일 수도 있음)")
                    } else {
                        debugPrint("📢 Raw Response:", responseData)
                    }
                }
            )
            .store(in: &cancellables)
    }
}

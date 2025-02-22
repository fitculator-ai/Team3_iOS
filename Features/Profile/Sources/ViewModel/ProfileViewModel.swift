//
//  ProfileViewModel.swift
//  Core
//
//  Created by Heeji Jung on 2/19/25.
//

import Foundation
import Core
import Combine
import UIKit

class ProfileViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    @Published public var MyPageRecord: MyPageData?
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    
    @Published var userGender: Gender = .male {
        didSet {
            MyPageRecord?.userGender = userGender.description
        }
    }
    
    func updateGender(from string: String) {
        self.userGender = Gender.fromString(string)
    }
    
//    if let userBirthString = viewModel.MyPageRecord?.userBirth, !userBirthString.isEmpty {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"  // 날짜 포맷이 맞는지 확인
//        if let convertedDate = dateFormatter.date(from: userBirthString) {
//            userBirth = convertedDate
//        }
//    } else {
//        userBirth = Date() // 기본값 설정
//    }

    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MyPage 데이터를 가져오는 메소드
    public func fetchMyPage(userId: Int) {
        isLoading = true
        
        // URL 생성
        let urlString = "http://13.125.175.216:8080/api/mypage?userId=\(userId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        
        print("Sending request to: \(urlString)")
        
        // URLSession 데이터 요청과 Combine 사용
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data } // 응답 데이터만 추출
            .decode(type: MyPageResponse.self, decoder: JSONDecoder()) // JSON 디코딩
            .receive(on: DispatchQueue.main) // 메인 스레드에서 처리
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false // 로딩 상태 종료
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.error = error
                        print("Error: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] response in
                    print("Decoded Response: \(response)")
                    self?.MyPageRecord = response.data
                }
            )
            .store(in: &cancellables)
    }

    //MARK: 사용자 정보 유효성 검사
    // 유저 이름
    public var isUserNameValid: Bool {
        guard let userName = MyPageRecord?.userName else {
            return false
        }
        return !userName.isEmpty && userName.count <= 15
    }
    
    // 유저 몸무게
    public var isUserWeightValid: Bool {
        if let record = MyPageRecord {
            return record.userWeight > 0
        }
        return false
    }
    
    // 유저 키
    public var isUserHeightValid: Bool {
        if let record = MyPageRecord {
            return record.userHeight > 0
        }
        return false
    }
    // 사용자 정보 유효성 전체 검사
    public var isFormValid: Bool {
        return isUserNameValid && isUserWeightValid && isUserHeightValid
    }
}

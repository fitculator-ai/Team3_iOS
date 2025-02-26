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
import Kingfisher

class ProfileViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    @Published public var MyPageRecord: MyPageData?
    
    @Published public var isLoading: Bool = false
    
    @Published public var error: Error?
    
    @Published var heartRateRequest: HeartRateRequest?
    
    @Published var profileImage: UIImage? {
        didSet {
            if let image = profileImage {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    profileImageString = imageData.base64EncodedString()
                }
            }
        }
    }
    
    @Published var profileImageString: String? = nil
    
    @Published var userGender: Gender = .man
    
    static func fromString(_ value: String) -> Gender? {
        switch value.uppercased() {
        case "MAN": return .man
        case "WOMAN": return .woman
        default: return nil
        }
    }

    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        return formatter
    }()

    
    
    @Published var isHeartRateValid: Bool = true
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        $MyPageRecord
                   .map { $0?.userHeartRate ?? 0 }
                   .sink { [weak self] heartRate in
                       self?.validateHeartRate(heartRate)
                   }
                   .store(in: &cancellables)
    }
    
    //MARK: 마이 페이지 (프로필) get
    public func fetchMyPage(userId: Int) {
        isLoading = true
        
        // URL 생성
        var urlString = NetworkConstants.baseURL + "/mypage?userId=\(userId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        
        print("Sending request to: \(urlString)")
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MyPageResponse.self, decoder: JSONDecoder())
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
                receiveValue: { [weak self] response in
                    self?.MyPageRecord = response.data
                    
                    if let heartRate = self?.MyPageRecord?.userHeartRate {
                        print("User Heart Rate: \(heartRate)")
                        self?.heartRateRequest = HeartRateRequest(userHeartRate: heartRate)
                    } else {
                        self?.heartRateRequest = HeartRateRequest(userHeartRate: 40)
                        print("Heart rate not found, using default value: 40")
                    }
                    
                    // S3 보안 설정 때문에 2시간 유효기간이 설정되어 있음
                    // 따라서 2시간마다 API 요청을 호출해야 함
                    // 현재는 테스트로 1분 후에 `fetchMyPage`를 호출하는 타이머를 설정
                    self?.reloadImagePeriodically(userId: userId)
                }
            )
            .store(in: &cancellables)
    }

    private func reloadImagePeriodically(userId: Int) {
        // 1분 후(테스트용)에 fetchMyPage를 호출하는 타이머 설정
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchMyPage(userId: userId)
        }
        
//        Timer.scheduledTimer(withTimeInterval: 7200, repeats: true) { [weak self] _ in
//               self?.fetchMyPage(userId: userId)
//           }
    }
    
    //MARK: 마이 페이지 (프로필) put
    func updateMyPage() {
        guard let userName = MyPageRecord?.userName,
              let userGender = MyPageRecord?.userGender,
              let userWeight = MyPageRecord?.userWeight,
              let userHeight = MyPageRecord?.userHeight,
              let userBirth = MyPageRecord?.userBirth,
              let userHeartRate = MyPageRecord?.userHeartRate
        else {
            print("Error: MyPageRecord is nil or incomplete data")
            return
        }
        
        let request = MyPageRequest(userId: 1,
                                    userName: userName,
                                    userGender: userGender,
                                    userWeight: userWeight,
                                    userHeight: userHeight,
                                    userBirth: userBirth,
                                    socialProvider: "exampleProvider", // 임시 값 추가
                                    userHeartRate: userHeartRate)
        
        let endpoint = APIEndpoint.updateMyPage(request: request)
        
        networkService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // DecodingError가 있는 경우
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                        case .valueNotFound(let value, let context):
                            print("Value '\(value)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch for type \(type): \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error: \(decodingError)")
                        }
                    }
                    
                case .finished:
                    break
                }
            }, receiveValue: { (response: MyPageResponse) in
                print("Success: \(response.success), Message: \(response.message)")
            })
            .store(in: &cancellables)
    }
    
    //MARK: 안정시 심박수 put
    func updateHeartRate(request: HeartRateRequest) {
        let endpoint = APIEndpoint.updateHeartRate(request: request)
        
        networkService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // 오류 처리 (디코딩 오류 처리)
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                        case .valueNotFound(let value, let context):
                            print("Value '\(value)' not found: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch for type \(type): \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error: \(decodingError)")
                        }
                    } else {
                        // 네트워크 오류 처리
                        print("Network error: \(error.localizedDescription)")
                    }

                case .finished:
                    break
                }
            }, receiveValue: { (response: HeartRateResponse) in
                // 성공적인 응답 처리
                print("Heart rate updated successfully. Success: \(response.success), Message: \(response.message)")
            })
            .store(in: &cancellables)
    }


    
    //MARK: 프로필 사진 get
    func fetchProfileImage(userId: Int) {
        let networkImageService = NetworkImageService()
        
        let endpoint = APIEndpoint.getMyPageProfileImage(userId: userId)
        
        networkImageService.fetchProfileImage(userId: userId, to: endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("이미지 가져오기 오류: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { profileImageResponse in
                print("가져온 프로필 이미지 URL: \(profileImageResponse)")
                
                if let imageFileName = profileImageResponse.data as? String {
                    print("파일명: \(imageFileName)")
                    
                    if let url = URL(string: imageFileName) {
                        print("전체 이미지 URL: \(url.absoluteString)")
                        
                        ImageDownloader.default.downloadImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                print("이미지 로딩 성공: \(value.image)")
                                self.profileImage = value.image
                                print("프로필 이미지 업데이트 완료")
                            case .failure(let error):
                                print("이미지 로딩 실패: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("유효하지 않은 URL: \(imageFileName)")
                    }
                }
            })
            .store(in: &cancellables)
    }

    
    //MARK: 프로필 사진 post
    func createProfileImage(userId: Int, image: UIImage) {
        isLoading = true
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to Data")
            return
        }
        
        let fileName = "profile_image_\(userId)_\(Date().timeIntervalSince1970).jpg"
         print("파일 이름: \(fileName)")
        
        let networkImageService = NetworkImageService()
        
        let endpoint = APIEndpoint.createMyPageProfileImage(userId: userId, filedata: "dummy")
        
        networkImageService.uploadProfileImage(userId: userId, imageData: imageData, to: endpoint)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                    self.error = error
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.success {
                    print("Profile image uploaded successfully. Message: \(response.message)")
                    print("Image URL: \(response.data)")
                } else {
                    print("Profile image upload failed: \(response.message)")
                }
            })
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
    
    // 심박수 유효성 검사 로직
    func validateHeartRate(_ heartRate: Int) {
         if heartRate >= 40 && heartRate <= 120 {
             print("Heart rate is valid: \(heartRate)")
         } else {
             print("Heart rate is invalid: \(heartRate)")
         }
        
        isHeartRateValid = (heartRate >= 40 && heartRate <= 120)
     }
    
    // 사용자 정보 유효성 전체 검사
    public var isFormValid: Bool {
        return isUserNameValid && isUserWeightValid && isUserHeightValid
    }
}

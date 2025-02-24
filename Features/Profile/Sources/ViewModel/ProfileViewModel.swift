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
        
    
    @Published var userGender: Gender = .male {
        didSet {
            MyPageRecord?.userGender = userGender.description
        }
    }
    
    func updateGender(from string: String) {
        self.userGender = Gender.fromString(string)
    }

    public lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    //MARK:  마이 페이지 (프로필) get
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
                    print("Decoded Response: \(response)")
                    self?.MyPageRecord = response.data
                }
            )
            .store(in: &cancellables)
    }
    
    
    //MARK: 마이 페이지 (프로필) put
    func updateMyPage() {
        guard let userName = MyPageRecord?.userName,
              let userGender = MyPageRecord?.userGender,
              let userWeight = MyPageRecord?.userWeight,
              let userHeight = MyPageRecord?.userHeight,
              let userBirth = MyPageRecord?.userBirth else {
            print("Error: MyPageRecord is nil or incomplete data")
            return
        }
        
        let request = MyPageRequest(userId: 1,
                                    userName: userName,
                                    userGender: userGender,
                                    userWeight: userWeight,
                                    userHeight: userHeight,
                                    userBirth: userBirth,
                                    socialProvider: "exampleProvider") // 임시 값 추가
        
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
                        
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let error = error {
                                print("이미지 요청 네트워크 오류: \(error.localizedDescription)")
                                return
                            }
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                print("HTTP 응답 코드: \(httpResponse.statusCode)")
                                if httpResponse.statusCode != 200 {
                                    print("이미지 요청 실패, 상태 코드: \(httpResponse.statusCode)")
                                    return
                                }
                            }
                            
                            // 데이터 로드 및 이미지 변
                            if let data = data {
                                print("받은 데이터 크기: \(data.count) bytes")
                                
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self.profileImage = image
                                        print("프로필 이미지 업데이트 완료")
                                    }
                                } else {
                                    print("이미지 변환 오류: 데이터가 UIImage로 변환되지 않음")
                                }
                            } else {
                                print("이미지 데이터 없음")
                            }
                        }.resume()
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
    // 사용자 정보 유효성 전체 검사
    public var isFormValid: Bool {
        return isUserNameValid && isUserWeightValid && isUserHeightValid
    }
}

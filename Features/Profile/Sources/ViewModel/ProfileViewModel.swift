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
            // 이미지가 변경되면 Base64 문자열로 변환하여 profileImageString에 저장
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
    
    //MARK:  마이 페이지 (프로필) get
    public func fetchMyPage(userId: Int) {
        isLoading = true
        
        // URL 생성
        let urlString = "http://13.125.175.216:8080/api/mypage?userId=\(userId)"
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
    func updateMyPage(request: MyPageRequest) {
        let endpoint = APIEndpoint.updateMyPage(request: request)
        
        networkService.request(endpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { (response: MyPageResponse) in
                // 응답 처리
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
                
                if let imageUrlString = profileImageResponse as? String,
                   let url = URL(string: imageUrlString) {
                    
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.profileImage = image
                            }
                        } else {
                            print("이미지 로드 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        }
                    }.resume()
                }
            })
            .store(in: &cancellables)
    }

    //MARK: 프로필 사진 post
    func createProfileImage(userId: Int, image: UIImage) {
        isLoading = true
        
        // UIImage -> Data 변환 (JPEG 형식)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to Data")
            return
        }
        
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

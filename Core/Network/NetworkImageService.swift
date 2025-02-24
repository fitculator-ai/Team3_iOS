//
//  NetworkImageService.swift
//  Core
//
//  Created by Heeji Jung on 2/24/25.
//

import Alamofire
import Combine
import Foundation

public protocol NetworkImageServiceProtocol {
    func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error>
    func uploadProfileImage(userId: Int, imageData: Data, to endpoint: APIEndpoint) -> AnyPublisher<ProfileImageResponse, Error>
    func fetchProfileImage(userId: Int, to endpoint: APIEndpoint) -> AnyPublisher<ProfileImageResponse, Error>  // 추가된 메서드
}

public final class NetworkImageService: NetworkImageServiceProtocol {
    public init() {}

    public func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        let url = NetworkConstants.baseURL + endpoint.path

        return AF.request(url,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default)
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    //MARK: 프로필 이미지를 업로드하는 메서드
    public func uploadProfileImage(userId: Int, imageData: Data, to endpoint: APIEndpoint) -> AnyPublisher<ProfileImageResponse, Error> {
        let url = NetworkConstants.baseURL + endpoint.path
        
        return Future { promise in
            AF.upload(multipartFormData: { formData in
                formData.append(imageData, withName: "file", fileName: "profileImage.jpg", mimeType: "image/jpeg")
                
                formData.append("\(userId)".data(using: .utf8)!, withName: "userId")
            }, to: url)
            .validate()
            .responseDecodable(of: ProfileImageResponse.self) { response in
                switch response.result {
                case .success(let profileImageResponse):
                    promise(.success(profileImageResponse))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    //MARK: 프로필 이미지를 가져오는 메서드
    public func fetchProfileImage(userId: Int, to endpoint: APIEndpoint) -> AnyPublisher<ProfileImageResponse, Error> {
        let url = NetworkConstants.baseURL + endpoint.path
        
        let parameters: [String: Any] = [
            "userId": userId
        ]
        
        return AF.request(url,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: endpoint.method == .get ? URLEncoding.default : JSONEncoding.default)
            .validate()
            .publishDecodable(type: ProfileImageResponse.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

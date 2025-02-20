//
//  NetworkService.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Alamofire
import Combine
import Foundation

public protocol NetworkServiceProtocol {
    func request<T: Codable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, Error>
}

public final class NetworkService: NetworkServiceProtocol {
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
}


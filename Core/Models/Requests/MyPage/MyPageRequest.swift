//
//  MyPageRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct MyPageRequest: Codable {
    let userId: Int
    let userName: String
    let userGender: String
    let weight: Int
    let height: Int
    let userBirth: String
    let socialProvider: String
    
    public func toDictionary() -> [String: Any] {
        return [
            "user_id": userId,
            "user_name": userName,
            "user_gender": userGender,
            "weight": weight,
            "height": height,
            "user_birth": userBirth,
            "social_provider": socialProvider
        ]
    }
}


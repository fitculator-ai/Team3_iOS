//
//  MyPageRequest.swift
//  Core
//
//  Created by JIHYE SEOK on 2/19/25.
//

import Foundation

public struct MyPageRequest: Codable {
    let userId: Int
    var userName: String
    var userGender: String
    var userweight: Int
    var userheight: Int
    var userBirth: String
    let socialProvider: String
    
    public func toDictionary() -> [String: Any] {
        return [
            "user_id": userId,
            "user_name": userName,
            "user_gender": userGender,
            "userweight": userweight,
            "userheight": userheight,
            "user_birth": userBirth,
            "social_provider": socialProvider
        ]
    }
}


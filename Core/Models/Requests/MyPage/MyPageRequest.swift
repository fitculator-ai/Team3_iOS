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
    var userWeight: Double
    var userHeight: Int
    var userBirth: String
    let socialProvider: String
    
    public func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "userName": userName,
            "userGender": userGender,
            "userWeight": userWeight,
            "userHeight": userHeight,
            "userBirth": userBirth,
            "socialProvider": socialProvider
        ]
    }
}

